import rospy
from uwds3_msgs.msg import WorldStamped


class WorldPublisher(object):
    def __init__(self, world_name, queue_size=1):
        self.publisher = rospy.Publisher(world_name, WorldStamped, queue_size=queue_size)

    def publish(self, tracks, events, header):
        """ """
        world_msg = WorldStamped()
        world_msg.header = header
        for track in tracks:
            if not track.is_tentative():
                world_msg.world.scene.append(track.to_msg(header))
        for event in events:
            world_msg.world.timeline.append(event.to_msg(header))
        self.publisher.publish(world_msg)
