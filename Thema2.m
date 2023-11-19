% Set the paths to the directories containing COVID and non-COVID X-ray images
covid_directory = 'C:\Users\demik\Desktop\CT_COVID';
noncovid_directory = 'C:\Users\demik\Desktop\CT_NonCOVID';

% Get the list of image files in the COVID directory
covid_files = dir(fullfile(covid_directory, '*.png'));
num_covid_files = numel(covid_files);

% Get the list of image files in the non-COVID directory
noncovid_files = dir(fullfile(noncovid_directory, '*.png'));
num_noncovid_files = numel(noncovid_files); 

% Preallocate variables
covid_images = zeros(240, 240, num_covid_files);
noncovid_images = zeros(240, 240, num_noncovid_files);

% Read and process COVID images
for i = 1:num_covid_files
    image = imread(fullfile(covid_directory, covid_files(i).name));
    if size(image, 1) > 300 && size(image, 2) > 300
        cropped_image = image(61:300, 61:300);
        covid_images(:, :, i) = im2double(cropped_image);
    end
end

% Read and process non-COVID images
for i = 1:num_noncovid_files
    image = imread(fullfile(noncovid_directory, noncovid_files(i).name));
    if size(image, 1) > 300 && size(image, 2) > 300
        cropped_image = image(61:300, 61:300);
        noncovid_images(:, :, i) = im2double(cropped_image);
    end
end

% Remove any zero-valued entries in the image arrays
covid_images(:, :, all(covid_images == 0, [1 2])) = [];
noncovid_images(:, :, all(noncovid_images == 0, [1 2])) = [];

% Calculate the number of valid COVID and non-COVID images
c19 = size(covid_images, 3);
nc19 = size(noncovid_images, 3);

% Reshape the images into vectors and create the Y matrix
covid_vectors = reshape(covid_images, [], c19);
noncovid_vectors = reshape(noncovid_images, [], nc19);
Y = [covid_vectors, noncovid_vectors];

% Calculate the mean image vector
mean_image = mean(Y, 2);

% Subtract the mean image vector from Y
Y_centered = Y - mean_image;

% Calculate the singular value decomposition of Y_centered
[U, ~, ~] = svd(Y_centered, 'econ');

% Extract the dominant left and right singular vectors if U has enough columns
if size(U, 2) >= 2
    u1 = U(:, 1);
    v1 = Y_centered' * u1;

    % Normalize u1 and v1
    u1 = u1 / norm(u1);
    v1 = v1 / norm(v1);

    % Check the projection of each column of Y onto u1
    projections = Y_centered' * u1;

    % Assign the signs to the projections
    signs = sign(projections);

    % Group the columns of Y based on the signs
    group1_indices = find(signs == 1);
    group2_indices = find(signs == -1);

    % Calculate the number of columns from each group belonging to COVID and non-COVID
    group1_covid = sum(group1_indices <= c19);
    group1_noncovid = sum(group1_indices > c19);
    group2_covid = sum(group2_indices <= c19);
    group2_noncovid = sum(group2_indices > c19);

    % Calculate the percentages
    covid_percentage = group1_covid / (group1_covid + group2_covid) * 100;
    noncovid_percentage = group1_noncovid / (group1_noncovid + group2_noncovid) * 100;

    % Apply NMF
    k = 2;  % Number of clusters/groups
    [W, H] = nnmf(Y, k, 'replicates', 5, 'algorithm', 'mult');

    % Normalize the columns of H
    H_normalized = H ./ max(H);

    % Group the columns of H_normalized
    [~, group_indices] = max(H_normalized, [], 2);
    group1_indices = find(group_indices == 1);
    group2_indices = find(group_indices == 2);

    % Calculate the number of columns from each group belonging to COVID and non-COVID
    group1_covid_nmf = sum(group1_indices <= c19);
    group1_noncovid_nmf = sum(group1_indices > c19);
    group2_covid_nmf = sum(group2_indices <= c19);
    group2_noncovid_nmf = sum(group2_indices > c19);

    % Calculate the percentages (considering the non-COVID case)
    noncovid_percentage_nmf = NaN;  
    if group1_noncovid_nmf + group2_noncovid_nmf > 0
        noncovid_percentage_nmf = group1_noncovid_nmf / (group1_noncovid_nmf + group2_noncovid_nmf) * 100;
    end

    % Display the results
    disp(['Percentage of COVID columns in COVID PDDP group: ', num2str(covid_percentage)]);
    disp(['Percentage of non-COVID columns in non-COVID PDDP group: ', num2str(noncovid_percentage)]);
    disp(['Percentage of COVID columns in COVID NMF group: ', num2str(covid_percentage)]);
    disp(['Percentage of non-COVID columns in non-COVID NMF group: ', num2str(noncovid_percentage_nmf)]);
else
    disp('Insufficient columns in U for further analysis.');
end
