%A.M.:1048924 -> COVID Image Selection
% I = imread('2020.01.24.919183-p27-132.png');
% whos I
% J = im2uint8(I); 
% whos J
% imwrite (J, '2020.01.24.919183-p27-132.png'); 


Image = imread('2020.01.24.919183-p27-132.png','png','BackgroundColor','none');
D = im2double(rgb2gray(Image)); %Turn image into gray scale and  into double class
whos D
figure
subplot(1,2,1)
imshow(Image)
title('Original COVID image')
subplot(1,2,2)
imshow(D)
title('Original gray scale COVID image')

%%Erotima a
[U,S,V]=svd(D); %% apply SVD algorithm
figure
semilogy(S,'.'); %% plot the S matrix (diagonal matrix)
title('Singular values graph')
% % create panel containing image on left and S graph on right
figure
subplot(1,2,1,'align')
imshow(D)
title('Original gray scale COVID image')
subplot(1,2,2,'align')
semilogy(S,'.')
title('Singular values graph')


%%Erotima b 
figure
subplot(3,2,1)
imshow(D)
title('Original image')
% k=2
subplot(3,2,2)
Q2=U(:,1:2)*S(1:2,1:2)*(V(:,1:2).');
norm2=norm(D-Q2);
fro2=norm(D-Q2, 'fro');
imshow(Q2)
title('k=2')
% k=16
subplot(3,2,3)
Q16=U(:,1:16)*S(1:16,1:16)*(V(:,1:16).');
norm16=norm(D-Q16);
fro16=norm(D-Q16, 'fro');
imshow(Q16)
title('k=16')
% k=64
subplot(3,2,4)
Q64=U(:,1:128)*S(1:128,1:128)*(V(:,1:128).');
norm64=norm(D-Q64);
fro64=norm(D-Q64, 'fro');
imshow(Q64)
title('k=64')
% kmine=550
subplot(3,2,5)
Q550=U(:,1:550)*S(1:550,1:550)*(V(:,1:550).');
norm550=norm(D-Q550);
fro550=norm(D-Q550, 'fro');
imshow(Q550)
title('k=550')

%%Erotima c
k=[2 16 64 550];
for i= 1:length(k)
        [B,er]=mono_compress(D,k(i));
        figure
        imshow(B)
end

%%Erotima d 
Q=2;
p = 2;
K = [2, 2; 1, 1];

[B, ER] = multi_compress(D, p, K);

figure;
subplot(1, 2, 1);
imshow(D);
title('Original COVID Image');
subplot(1, 2, 2);
imshow(B);
title('Multicompressed COVID Image');

figure;
imshow(ER, 'DisplayRange', [0, max(ER(:))]);
colorbar;
title('Error Matrix');
