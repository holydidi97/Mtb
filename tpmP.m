P = [
    (1-p)+p/N,   p/N,   p/N,   ...,   p/N;
    p/N,   (1-p)+p/N,   p/N,   ...,   p/N;
    p/N,   p/N,   (1-p)+p/N,   ...,   p/N;
    ...
    p/N,   p/N,   p/N,   ...,   (1-p)+p/N
];

% Print the transition probability matrix P
disp('Transition probability matrix P:');
disp(P);
