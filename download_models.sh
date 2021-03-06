rm -rf models/detection
rm -rf models/features
rm -rf models/estimation

mkdir -p models/detection
cd models/detection

wget https://raw.githubusercontent.com/opencv/opencv/master/samples/dnn/tf_text_graph_common.py
wget https://raw.githubusercontent.com/opencv/opencv/master/samples/dnn/tf_text_graph_ssd.py
wget https://raw.githubusercontent.com/opencv/opencv/master/samples/dnn/tf_text_graph_mask_rcnn.py

wget http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v2_coco_2018_03_29.tar.gz
tar xvzf ssd_mobilenet_v2_coco_2018_03_29.tar.gz
mv ssd_mobilenet_v2_coco_2018_03_29/frozen_inference_graph.pb ssd_mobilenet_v2_coco_2018_03_29.pb
wget https://raw.githubusercontent.com/opencv/opencv_extra/master/testdata/dnn/ssd_mobilenet_v2_coco_2018_03_29.pbtxt
rm ssd_mobilenet_v2_coco_2018_03_29.tar.gz
rm -rf ssd_mobilenet_v2_coco_2018_03_29/

# wget http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v3_large_coco_2020_01_14.tar.gz
# tar xvzf ssd_mobilenet_v3_large_coco_2020_01_14.tar.gz
# mv ssd_mobilenet_v3_large_coco_2020_01_14/frozen_inference_graph.pb ssd_mobilenet_v3_large_coco_2020_01_14.pb
# python tf_text_graph_ssd.py --input ssd_mobilenet_v3_large_coco_2020_01_14.pb --output ssd_mobilenet_v3_large_coco_2020_01_14.pbtxt --config ssd_mobilenet_v3_large_coco_2020_01_14/pipeline.config
# rm -rf ssd_mobilenet_v3_large_coco_2020_01_14
# rm -rf ssd_mobilenet_v3_large_coco_2020_01_14.tar.gz

wget http://download.tensorflow.org/models/object_detection/mask_rcnn_inception_v2_coco_2018_01_28.tar.gz
tar xvzf mask_rcnn_inception_v2_coco_2018_01_28.tar.gz
mv mask_rcnn_inception_v2_coco_2018_01_28/frozen_inference_graph.pb mask_rcnn_inception_v2_coco_2018_01_28.pb
python tf_text_graph_mask_rcnn.py --input mask_rcnn_inception_v2_coco_2018_01_28.pb --output mask_rcnn_inception_v2_coco_2018_01_28.pbtxt --config mask_rcnn_inception_v2_coco_2018_01_28/pipeline.config
rm -rf mask_rcnn_inception_v2_coco_2018_01_28
rm -rf mask_rcnn_inception_v2_coco_2018_01_28.tar.gz


wget https://raw.githubusercontent.com/opencv/opencv_extra/master/testdata/dnn/opencv_face_detector.pbtxt
wget https://github.com/opencv/opencv_3rdparty/raw/8033c2bc31b3256f0d461c919ecc01c2428ca03b/opencv_face_detector_uint8.pb

cd -
mkdir -p models/estimation
cd models/estimation
wget http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2
bzip2 -d shape_predictor_68_face_landmarks.dat.bz2
rm shape_predictor_68_face_landmarks.dat.bz2

cd -
mkdir models/features
cd models/features
wget https://storage.cmusatyalab.org/openface-models/nn4.small2.v1.t7
wget https://raw.githubusercontent.com/shicai/MobileNet-Caffe/26a8b8c0afb6114a07c1c9e4f550e4e0dd8cced1/mobilenet_v2_deploy.prototxt
wget https://github.com/shicai/MobileNet-Caffe/raw/26a8b8c0afb6114a07c1c9e4f550e4e0dd8cced1/mobilenet_v2.caffemodel
