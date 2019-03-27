function output = faceRecognition(img)
    %% loading t data into mat v.
    clc
    V = double(loadDatabase());
    u = size(img);
    
    %% inits.
    % choose image and get its vector to search for it in the data.
    T = reshape(img,u(1)*u(2),1);
    [W,H] = nnmf(V,16); 
    W = double(W);
    H = double(H);

    % matrix is singular, using SVD pseudo inverse to solve.
    if det(W'*W)==0
        Ht = pinv(W'*W)*W'*double(T);   
    else
        Ht = inv(W'*W)*W'*double(T);
    end
    
    %% recognition.
    %  recognize face.
    subplot(121); 
    imshow(reshape(img,112,92));title('Searching for','FontWeight','bold','Fontsize',16,'color','black');
    subplot(122)
    o = size(H);
    
    % performing comparison betwen h_test and h_i.
    for i = 1:o(2)
        s(i) = (1/((norm(H(:,i))*norm(Ht))))*dot(H(:,i),Ht);
        if mod(i,10)==0
            q = reshape(V(:,i),112,92);
            image(q);title('Please wait','FontWeight','bold','Fontsize',16,'color','black');
            axis off
            drawnow
        end
    end
    
    h_threshold = 0.86;

    % Person is in the database.
    if max(s) >= h_threshold
        [M,I] = max(s);
        l = V(:,I);
        l = reshape(l,112,92);
        image(l);title('Found!','FontWeight','bold','Fontsize',16,'color','black');
        axis off
        output = I;
    % Person is not in the database
    else
        imshow(ones(112,92));title('Target is not in the Data base','FontWeight','bold','FontSize',16,'color','black');
        output = [];
end