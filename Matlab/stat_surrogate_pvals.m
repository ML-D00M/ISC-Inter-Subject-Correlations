function pvals = stat_surrogate_pvals(distribution,observed,tail)
% compute empirical p-vals under the null hypothesis that observed samples
% come from a given surrogate distribution. P-values for Type I error in
% rejecting the null hypothesis are obtained by finding the proportion of
% samples in the distribution that
% (a) are larger than the observed sample (one-sided test)
% (b) are larger or smaller than the observed sample (two-sided test).
%
% This function is based on Arnaud Delorme's statcond:compute_pvals()
% function from EEGLAB
% 
% Inputs:
%
%   distribution:   [d1 x d2 x ... x dM x N] matrix of surrogate samples. 
%                   distribution(i,j,k,...,:) is a collection of N samples
%                   from a surrogate distribution.
%   observed:       [d1 x d2 x ... x dM] matrix of observations.
%   tail:           can be 'one' or 'both' indicating a one-tailed or
%                   two-tailed test
% Outputs:
%   
%   pvals:          [d1 x d2 x ... x dM] matrix of p-values specifying
%                   probability of Type I error in rejecting the null 
%                   hypothesis
% 
% Author: Tim Mullen and Arnaud Delorme, SCCN/INC/UCSD
			
numDims = 3;
	
% append observed to last dimension of surrogate distribution
distribution = cat(numDims,distribution,observed);
	
% sort along last dimension (replications)
[tmp idx] = sort( distribution, numDims,'ascend');
[tmp mx]  = max( idx,[], numDims);

len = size(distribution,  numDims );
pvals = 1-(mx-0.5)/len;

end
