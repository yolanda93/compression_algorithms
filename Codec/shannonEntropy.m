function bitsPerSymbol = shannonEntropy(matrix)
    a = unique(matrix);
    count = numel(matrix);
    out = [a,histc(matrix(:),a)/count];
    p = out(:,2);
    H = sum(-(p(p>0).*(log2(p(p>0))))); % Shannon entropy formula
    bitsPerSymbol = H;
end