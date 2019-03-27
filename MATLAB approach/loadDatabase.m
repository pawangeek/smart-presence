% Load the database the first time we run the program.
function out = loadDatabase()
	persistent w;
	
	% Read number of workers in database.
	fileID = fopen('numberDataBase.txt','r');
	n = fscanf(fileID,'%d');
	
	% The size of each image is 112x92 = 10304.
	% Making a 10304xn*10 input data matrix.
	v = zeros(10304,n*10);
	
	for i = 1:n
	    cd(strcat('s',num2str(i)));
	    for j = 1:10
	        % Read image data from graphics file.
	        a = imread(strcat(num2str(j),'.pgm'));
			% If the file contains a grayscale image, a is an M-by-N array.
	        v(:,(i-1)*10+j) = reshape(a,size(a,1)*size(a,2),1);
	    end
	    cd ..
	end
	
	% Convert to unsigned 8 bit numbers to save memory.
	w = uint8(v);
out = w;