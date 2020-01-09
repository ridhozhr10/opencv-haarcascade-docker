#include "opencv2/objdetect.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"
#include "opencv2/videoio.hpp"
#include <iostream>
using namespace std;
using namespace cv;

void detectFaceImage(Mat frame, vector<Rect> &faces);
void detectAndDisplay(Mat frame);

CascadeClassifier face_cascade;

int main(int argc, const char **argv)
{
  CommandLineParser parser(argc, argv,
                           "{help h||}"
                           "{face_cascade|../haarcascades/haarcascade_frontalface_alt.xml|Path to face cascade.}"
                           "{input_image|./input.jpeg|peg file}");
  String flag_help = parser.get<String>("help");
  if (!flag_help.empty())
  {
    parser.printMessage();
    return 0;
  }

  String face_cascade_name = samples::findFile(parser.get<String>("face_cascade"));
  String input_image = parser.get<String>("input_image");
  //-- 1. Load the cascades
  if (!face_cascade.load(face_cascade_name))
  {
    cout << "--(!)Error loading face cascade\n";
    return -1;
  };

  Mat frame = imread(input_image);
  if (frame.empty())
  {
    cout << "--(!)Error getting image " << input_image << endl;
    return -1;
  }

  std::vector<Rect> faces;
  detectFaceImage(frame, faces);
  cout << "count total image detected : " << faces.size() << endl;

  return 0;
}

void detectFaceImage(Mat frame, vector<Rect> &faces)
{
  Mat frame_gray;
  cvtColor(frame, frame_gray, COLOR_BGR2GRAY);
  equalizeHist(frame_gray, frame_gray);
  face_cascade.detectMultiScale(frame_gray, faces);
}