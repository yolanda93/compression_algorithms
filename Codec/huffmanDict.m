function dict = huffmanDict(matrix)
    a = unique(matrix);
    count = numel(matrix);
    out = [a,histc(matrix(:),a)/count];
    p = out(:,2);
    dict = huffmandict(a,p);
end