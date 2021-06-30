## Inter-subject correlation (ISC) for EEG data

This repository contains several functions for calculating inter-subject correlation for electroencephalography (EEG) data, both in Python (project of 2020) and Matlab (project of 2021).
The algorithm was described in details in the article
[Correlated Components of Ongoing EEG Point to Emotionally Laden Attention – A Possible Marker of Engagement?](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3353265/)

### Matlab repository

Here you can find code for all preprocessing stages as well as for inter-subject correlation anlysis.

In `step1_extractTriggers` we read the data of all the subjects, read the triggers and align them with the recordings, then save the complete matrix (data + triggers).

In `step2_segmentation` we extract the recordings of all the videos (9) of our experiment.

In `step3_TemporalAlignment` we temporally align the data of all subjects for each video, thus preparing for the ISC analysis.

In `step4_preprocessing` we preprocess the data in a format T x D x N (where T - time samples, D - number of electrodes, N - number of subjects). Here we high-pass filter (0.5 Hz) and notch-filter (50 Hz) the data. Eye-movement artifacts are were removed by linearly regressing the EOG channels from the EEG channels. Since the covariance matrices used in the ISC computation are sensitive to outliers, values above three standard deviations of the mean in each electrode separately should be replaced by zero values.

In `step5_isceeg_with_time_windows`correlated component analysis (CorrCA) is implemented and correlation coefficients called intersubject correlation (ISC) are calculated. Here we also calculate ISC across 1s time windows (with 0.8s overlap) and plot the ISC time series
To check the calculated ISC time series for statistical significance we employed a non-parametric permutation test. By scrambling the phases of the Fourier transform of the signals and transforming these scrambled signals back to the time domain, we created surrogate data. While repeating this procedure 100 times, ISC was calculated each time to generate a null distribution of ISC values. The actual ISC value obtained from the original data was then ranked among the empirical null distribution, resulting in a p-value.

### Python repository

`ISC.py` contains all necessary functions for calculating Inter-subject correlation (ISC). The function `train_cca(data)` takes a dictionary
where keys are names of conditions and values are 3-D numpy arrays structured like `(subjects, channels, samples)`. It returns 
a 2-D numpy array `W` with all spatial filters (which maximize correlation in the data) in descending order.

The function `apply_cca(X, W, fs)` takes the same `X` as for training, numpy array of spatial filters and frequency sampling.
It returns ISC, ISC_persecond, ISC_bysubject values and scalp projections of spatial filters `A`.

You can run the example below:

```
X = dict(Sin=np.random.rand(10, 32, 512*60))
X['Sin'][:,24,:] = np.sin(np.linspace(-np.pi, np.pi, 512*60))
[W, ISC_overall] = train_cca(X)

isc_results = dict()
for cond_key, cond_values in X.items():
    isc_results[str(cond_key)] = dict(zip(['ISC', 'ISC_persecond', 'ISC_bysubject', 'A'], apply_cca(cond_values, W, 250)))
```

For the visualization you should just run `visualization.py` after spatial filters are applied.
