function [B,er]=mono_compress(Q,k)
[U,S,V]=svd(Q);
B=U(:,1:k)*S(1:k,1:k)*(V(:,1:k).');
er=norm(Q-B);
end

