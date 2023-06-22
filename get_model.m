function [trained_mdl, accuracy, predicted_val, true_val] = get_model(X, Y, mdl_template, holdout)

% test train split
n = height(X);
cv = cvpartition(n,'Holdout', holdout); % Nonstratified partition
idx = cv.test;

X_train = X(~idx,:);
Y_train = Y(~idx,:);

X_test = X(idx, :);
Y_test = Y(idx, :);

% train
trained_mdl = fitcecoc(X_train, Y_train, 'Learners', mdl_template);

% prediction and accuracy
predicted_val = predict(trained_mdl, X_test);
true_val = Y_test;

accuracy = sum(true_val == predicted_val,'all')/numel(predicted_val);

end

