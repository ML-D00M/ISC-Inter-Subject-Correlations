## Inter-subject correlation (ISC) for EEG data

This repository contains several functions for calculating inter-subject correlation for electroencephalography (EEG) data.
The algorithm was described in details in the next article
[Correlated Components of Ongoing EEG Point to Emotionally Laden Attention – A Possible Marker of Engagement?](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3353265/)

### Getting started

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

#### Some features will be added soon:
1. Topoplot visualization
2. Adjusting for multiple comparison
3. Simultaneous video playing and `ISC_persecond`
