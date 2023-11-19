% Exercise parameters
p = 0.5;  % Probability of mutation
N = 4;    % Number of possible mutations
t = 5;    % Number of generations

% (a) Define state space S and transition probability matrix P
S = {'A', 'B', 'C', 'D'};
P = (1-p)*eye(N) + (p/N)*ones(N);

% (b) Calculate the expected value E[T]
E_T = 2 - p;

% (c) Calculate the probability of finding all mutations in the first t generations
P_all_mutations = (1-p)^t * 1/N^t;

% (d) The process {Yt}t>=1 is not a Markov chain

% Display results
disp('(a) State space S:');
disp(S);
disp('Transition probability matrix P:');
disp(P);
disp('(b) Expected value E[T]:');
disp(E_T);
disp('(c) Probability of finding all mutations in the first t generations:');
disp(P_all_mutations);
disp('(d) The process {Yt}t>=1 is not a Markov chain.');
