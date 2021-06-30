import numpy as np
from timeit import default_timer
import numpy.matlib as npm



def shuffle_in_time(data, window, fs):
    data_shuffled = dict()

    for cond, values in data.items():
        cond_shuffled = np.zeros(values.shape)
        n_samples = values[0].shape[1]
        n_splits = n_samples/fs/window

        for subj_i, subj in enumerate(values):
            for ch_i, ch in enumerate(subj):
                splitted = np.array_split(ch, n_splits)
                np.random.shuffle(splitted)
                ch_shuffled = np.concatenate(splitted)
                cond_shuffled[subj_i, ch_i, :] = ch_shuffled

        data_shuffled[str(cond)] = cond_shuffled

    return data_shuffled

def phaserandomized(X):
    """Calculates phase randomized data based on real data. The full algorithm is described here Pritchard 1991.

        Parameters:
        -------
        X : ndarray
            3-D numpy array structured like (subject, channel, sample)

        Returns:
        -------
        Xr : ndarray
            3-D numpy array structured like (subject, channel, sample) with random phase added

    """
    start = default_timer()

    N, D, T = X.shape
    print(f'\n{N} subjects, {D} sensors and {T} samples')

    Xr = np.empty((N, D, T))

    for subject in range(0, N):

        Xfft = np.fft.rfft(X[subject, :, :], T)
        ampl = np.abs(Xfft)
        phi = np.angle(Xfft)
        # np.random.seed(42)
        phi_r = 4 * np.arccos(0) * np.random.rand(1, int(T / 2 - 1)) - 2 * np.arccos(0)
        Xfft[:, 1:int(T / 2)] = ampl[:, 1:int(T / 2)] * np.exp(
            np.sqrt(-1 + 0j) * (phi[:, 1:int(T / 2)] + npm.repmat(phi_r, D, 1)))
        Xr[subject, :, :] = np.fft.irfft(Xfft, T)

    stop = default_timer()
    print(f'Elapsed time: {round(stop - start)} seconds.')

    return Xr
