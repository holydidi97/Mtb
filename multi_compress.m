function [B, ER] = multi_compress(Q, p, K)
    [m, n] = size(Q);
    blockSize = floor([m, n] ./ p);
    B = zeros(size(Q));
    ER = zeros(p);

    for i = 1:p
        for j = 1:p
            rowStart = (i - 1) * blockSize(1) + 1;
            rowEnd = i * blockSize(1);
            colStart = (j - 1) * blockSize(2) + 1;
            colEnd = j * blockSize(2);
            
            submatrix = Q(rowStart:rowEnd, colStart:colEnd);
            k = K(i, j);
            [U, S, V] = svd(submatrix);
            B(rowStart:rowEnd, colStart:colEnd) = U(:, 1:k) * S(1:k, 1:k) * V(:, 1:k)';
            ER(i, j) = norm(submatrix - B(rowStart:rowEnd, colStart:colEnd), 'fro');
        end
    end
end
