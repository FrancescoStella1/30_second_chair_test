# 30_second_chair_test
Implementation of the 30 Second Chair Stand Test for the Biomedical Signal Processing course.

*Pleas notice, this is a test software and should not be used as a medical test.*

### Requirements:
* A smartphone provided at least with an accelerometer and a gyroscope.
* Matlab Mobile installed on the smartphone:
  * Android: [link](https://play.google.com/store/apps/details?id=com.mathworks.matlabmobile&hl=it&gl=US)
  * iOS: [link](https://apps.apple.com/it/app/matlab-mobile/id370976661)
* Matlab installed on PC


## Assessment of the 30 Second Chair Stand Test
1. The test should start with the subject sitting in the middle of a chair, firmly holding the smartphone in one hand with the screen facing upwards, i.e. with Z-axis perpendicular to the floor. Please refer to the following image from Mathworks website:
![Axes orientation](https://www.mathworks.com/matlabcentral/answers/uploaded_files/162922/image.jpeg)

2. The subject should keep his/her hands on the opposite shoulders crossed at the wrists, the feet flat on the floor and the back straight.

3. For 30 seconds, the subject should rise to a full standing position and then sit back again, repeating the movement in a controlled and continuous way.

For further details, you can read the following material:

- [Test Assessment](https://www.cdc.gov/steadi/pdf/STEADI-Assessment-30Sec-508.pdf)
- [Millor et al. paper](https://www2.unavarra.es/gesadj/depCSalud/mikel_izquierdo/06472000.pdf)


## Usage
**Please notice that the software assumes a sampling frequency set to 100Hz.** You can set it in the settings of Matlab Mobile.
Once the .mat files are retrieved from the smartphone, they should be put in the *'MobileSensorData'* directory.
You should change the filename variable in the *'src/main.m'* with the file you want to use (e.g. filename = 'file1.mat').

The software will return some kinematic parameters and the count of the valid sit-stand-sit cycles.
