%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author :- Manas Kumar Mishra
% Function for implement FIR filtering operation in time domain
% y[n] = h1*x[n]+h2*x[n-1]+h3*x[n-2]+... 729
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Inputs are the discrete time signal and filter cofficients
% Output is the filtered signal using filter cofficients

function FilteredSignal = myFIRFilter(Signal1, Filter_coff)
    
    N = length(Signal1);
    
    FilteredSignal = zeros(1, N); %Initailize the filtered signal

    interVector = zeros(1, length(Filter_coff));
    
    sum=0;

    for i =1:N
        interVector(1)=Signal1(i);
        intermulti = zeros(1, length(Filter_coff));
        
        %Multiply elemenet by element
        intermulti = Filter_coff.*interVector;
        
        %Apply sum
        for k =1:length(intermulti)
            sum = sum + intermulti(k);
        end
        
        FilteredSignal(i) = sum;
        sum =0; % Reintailize the sum 
        
        %Shifting operation
        for j =length(interVector):-1:2
            interVector(j)= interVector(j-1);
        end
    end
end