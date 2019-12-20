%---------------------------------------------------------------------------
%
%    PROJECT:        -
%    PACKAGE:        (signal processing / general tools)
%    FILE:           'resampl1.m'
%
%    PURPOSE:        Provide 1-pass fixed-rate linear resampling
%    VERSION:        1.0
%
%    STAGE:          BETA
%    UPDATED:        05-Jan-2017/10:00
%
%    HISTORY:        version 1.0: implemented core functionality (05-Jan-2017/10:00)
%
%    DESCRIPTION:    This is a template stand-alone code (no externals required) for a 
%                    simple 1-pass fixed rate linear resampler. Specifically, the script
%                    can be used as-is or as base for a function, which take a series of
%                    pairs <t,x> and a requested fixed resampling rate and it produces
%                    a new series of <t',x'> using stepwise linear regressors.
%                    The script includes a data sorting step against <t>, which is not
%                    implemented here internally and can be removed if the input data
%                    are already expected to be sorted. In case of no sorting step here,
%                    the script is completely 1-pass, which means that all elements of
%                    the two input vectors (ref. points) are read only once for the 
%                    entire resampling process. This is particularly useful when this
%                    implementation is to be applied directly to extremely large input 
%                    files (e.g. columns in .csv) with only minimal memory usage for
%                    the calculations and only sequential read mode for speed.
%
%    INPUT:          Tt : [Nx1] column vector with timestamps (e.g. secs)
%                    Xt : [Nx1] column vector with data series (ref. points)
%                    Trate : (scalar) arbitrary fixed-rate for resampling
%
%    OUTPUT:         Nr : (scalar) length of new column vectors
%                    D  : [Nr x2] two column vectors with resampled points
%                            D(Nr,1) : new timestamps
%                            D(Nr,2) : new data series
%
%    NOTE:           This work is supported by the DART project (H2020): "Data-Driven 
%                    Aircraft Trajectory Prediction Research" (http://dart-research.eu) 
%                    and the Data Science Lab (http://www.datastories.org) at the 
%                    University of Piraeus, Greece (http://www.unipi.gr).
%
%    AUTHOR:         Harris Georgiou (MSc,PhD) - IS/IT Engineer (R&D)
%    COPYRIGHT:      Data Science Lab @ UniPi (c) 2017 - http://datastories.org
%    LICENCE:        Creative Commons (CC-BY-SA) 4.0/I - http://creativecommons.org
%
%---------------------------------------------------------------------------


%... initialize ...

clear all;

% create a sample random walk to test the process
% employ N steps of (5 +/- 5) value change in each
N=10;
Tt=rand(N,1)*10; for k=2:N, Tt(k)=Tt(k-1)+Tt(k); end;
Xt=rand(N,1)*10; for k=2:N, Xt(k)=Xt(k-1)+Xt(k); end;

% set the resampling fixed rate (normally: < Trange/N)
Trate=2;

%... linear interpolation for resampling ...

% step 1: sort against T
% (can be removed if already sorted)
[Tts,si]=sort(Tt);
Xts=Xt(si);
disp([Tts Xts]);

% step 2: resample with new (fixed) rate
Trng=Tts(N)-Tts(1);         % true value range for T
Xrng=Xts(N)-Xts(1);         % true value range for X
Nr=ceil(Trng/Trate)+1;      % add one more for last extrapolation
D=zeros(Nr,2);              % pre-allocate results for speed

D(1,:)=[Tts(1) Xts(1)];     % fill-in from initial point (true)
u=2;                        % initialize upper bound for search
for k=2:Nr-1
    D(k,1)=D(k-1,1)+Trate;                  % 1: update timestamp (resampled)
    while (D(k,1)>=Tts(u)),  u=u+1;  end;   % 2: update upper bound (T.high)
    
    % 3: use current frame to resample data value using piecewise linear interpolation
    D(k,2) = (Xts(u)-Xts(u-1))/(Tts(u)-Tts(u-1)) * (D(k,1)-Tts(u-1)) + Xts(u-1); 

    % 4: display new point id, upper bound id, current frame, resampled value
    fprintf('k=%d, u=%d:  %g <= %g < %g : %g\n',k,u,Tts(u-1),D(k,1),Tts(u),D(k,2));    
end

% step 3: extrapolate for last point (same as in-loop)
D(Nr,1)=D(k,1)+Trate;
D(Nr,2) = (Xts(u)-Xts(u-1))/(Tts(u)-Tts(u-1)) * (D(Nr,1)-Tts(u-1)) + Xts(u-1); 
fprintf('Nr=%d, u=%d:  %g <= %g < %g : %g\n',Nr,u,Tts(u-1),D(Nr,1),Tts(u),D(Nr,2));    

%... plot results ...
figure(1);
plot(Tts,Xts,'bo-',D(:,1),D(:,2),'r.');
msg=sprintf('Linear resampling: orig.rate=%.2f (+/-%.2f) => new.rate=%g',mean(diff(Tts)),std(diff(Tts)),Trate);
title(msg);
xlabel('Time (t)');  ylabel('Value (X(t))');
legend('true values (o)','lin.interp.(.)','Location','SouthEast');

% main result: D(,)=<t',x'> with Nr rows
