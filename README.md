# R wave Detection of ECG Signals 💓

[ECG Signal](https://github.com/Yuvalmaster/ECG-Rwave-Detection/assets/121662835/56a1c689-f4f1-4133-aa4f-2c0ee2dc9c19)

## Project Description
### Overview
The primary objective of this project is to accurately detect the R wave, a prominent feature in the ECG waveform that corresponds to ventricular depolarization. Detecting the R wave accurately is crucial for multiple applications, including heart rate calculation, arrhythmia detection, and ECG-based diagnostic systems.

## Signal Processing Techniques
To achieve accurate R wave detection, the project employs advanced signal processing techniques. These techniques are designed to enhance the accuracy and reliability of subsequent analyses. The key steps involved in this project module are as follows:

* **Signal Filtering**: The ECG signals are subjected to various filtering techniques to remove noise and artifacts. These techniques several low/high pass filters. The application of these filters ensures that the subsequent analysis is performed on clean and reliable signals.

* **R Wave Detection algorithm**: Once the ECG signals have been filtered, the project focuses on detecting the R wave. This detection process involves AF2 algorithm combinied with specifically designed methods to identify the characteristic waveform pattern associated with the R wave. Accurate detection of the R wave enables precise measurement of heart rate and facilitates the identification of arrhythmias.

### AF2 algorithm
The AF2 algorithm is an adaptation of the analog QRS detection scheme developed by Fraden and Neuman in 1980. It is used for the identification of R waves in ECG waveforms. Here is a summary of the algorithm steps:

* Threshold Calculation: A threshold is determined as a fraction of the peak value of the ECG signal.

* Rectification: The ECG signal is rectified to ensure all values are positive.

* Low-Level Clipping: The rectified ECG signal is passed through a low-level clipper, where values above the threshold are retained, and values below the threshold are clipped.

* First Derivative Calculation: The first derivative of the clipped, rectified ECG signal is calculated at each sample point to capture rapid changes in the waveform.

* QRS Candidate Detection: QRS candidates are identified when points in the first derivative signal exceed a fixed constant threshold.

By following these steps, the AF2 algorithm aims to detect R waves, which correspond to the QRS complexes in the ECG waveform. It utilizes thresholding and derivative-based methods to identify potential R waves and enable further analysis or applications such as heart rate calculation, arrhythmia detection, and diagnostic systems based on ECG signals.

## Repository Structure
The repository is structured in a way that facilitates easy navigation and utilization of the project resources. Here's an overview of the main components:

* Functions: The Functions folder contains MATLAB functions and scripts that are essential for signal processing, R wave detection, and related analyses.

* Data: The Data folder contains the ECG signals used in the project.
