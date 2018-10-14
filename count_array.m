function arrayOut = count_array(arrayIn,base)
%COUNT_ARRAY Increment array using the given base
%   Counting starts at 1 for array indexing purposes

len = length(arrayIn);
arrayOut = arrayIn;

if all(arrayIn == base)
    arrayOut = ones(size(arrayIn));
end

if arrayIn(len) < base
    arrayOut(len) = arrayIn(len) + 1;
else
    arrayOut = [count_array(arrayIn(1:len - 1), base), 1];
end

end