// 207521642 Ella Kharakh
#include <stdbool.h> 
//I used a Test script written by Ron Even
typedef struct {
   unsigned char red;
   unsigned char green;
   unsigned char blue;
} pixel;

typedef struct {
    int red;
    int green;
    int blue;
    // int num;
} pixel_sum;



/*
 *  Applies kernel for pixel at (i,j)
 */
static pixel applyKernel(int dim, int i, int j, pixel *src, int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter) {
	int ii, jj;
	// optimisation: we use num1, num2, to calculate here and save the value, instead of using calcindex
	int num1;
	int num2;
	int weight;
	int redNum, greenNum, blueNum;
	unsigned char redC, greenC, blueC;
	int redCnum, greenCnum, blueCnum;
	pixel p;
	pixel_sum sum;
	pixel current_pixel;
	int min_intensity = 766; // arbitrary value that is higher than maximum possible intensity, which is 255*3=765
	int max_intensity = -1; // arbitrary value that is lower than minimum possible intensity, which is 0
	int min_row, min_col, max_row, max_col;
	pixel loop_pixel;
	//optimisation: instead of using initialize_pixel_sum, we initialize it here
	sum.red = sum.green = sum.blue = 0;
	int x1, y1, z1;
	//optimisation: instead Of Using CalcIndex, we alculate it here
	int insteadOfUsingCalcIndex;
	//optimisation: instead Of calling min a lot of times throught loop, we doent call it, we just do the check if a<b here.
	int minOfFirstLoop, minOfSecondLoop;
	//int minOfFirstLoop = min(i+1, dim-1);
	if(i < dim - 1){
		minOfFirstLoop = i+1;
	}
	else {
		minOfFirstLoop = dim - 1;
	}
	if(j  < dim - 2){
		minOfSecondLoop = j+1;
	}
	else {
		minOfSecondLoop = dim - 1;
	}
	//int minOfSecondLoop = min(j+1, dim-1);
	int jjtemp;
	int x;
	if(i  >  1){
		ii = i-1;
	}
	else {
		ii = 0;
	}
	if(j > 1){
		jjtemp = j-1;
	}
	else{
		jjtemp = 0;
	}

	//optimisation: instead Of Using CalcIndex, we alculate it here
	insteadOfUsingCalcIndex = ii * dim + jjtemp;

	for(; ii <= minOfFirstLoop; ++ii) {
		for(jj = jjtemp; jj <= minOfSecondLoop; ++jj) {
			//optimisation: instead Of Using CalcIndex, we alculate it here
			int kRow, kCol;

			// compute row index in kernel
			
			kRow = ii - i + 1;
			kCol = jj - j + 1;
			
			loop_pixel = src[insteadOfUsingCalcIndex];

			// apply kernel on pixel at [ii,jj]
			// sum_pixels_by_weight(&sum, loop_pixel, kernel[kRow][kCol]);
			weight = kernel[kRow][kCol];

			// optimisation: use whats writen in sum_pixels_by_weight without using the func
			
			redNum = sum.red;
			greenNum = sum.green;
			blueNum = sum.blue;
			redC = loop_pixel.red;
			greenC = loop_pixel.green;
			blueC = loop_pixel.blue;
			
			redCnum = (int) redC;
			greenCnum = (int) greenC;
			blueCnum = (int) blueC;
			
			redNum += redCnum * weight;
			greenNum += greenCnum * weight;
			blueNum += blueCnum * weight;
			
			sum.red = redNum;
			sum.green = greenNum;
			sum.blue = blueNum;
			//optimisation: instead Of Using CalcIndex, we alculate it here
			if(filter){
				x1 = (int) loop_pixel.red;
				y1 = (int) loop_pixel.green;
				z1 = (int) loop_pixel.blue;
				x = x1 + y1 + z1;
				if (x <= min_intensity) {
					min_intensity = x;
					min_row = ii;
					min_col = jj;
				}
				if (x > max_intensity) {
					max_intensity = x;
					max_row = ii;
					max_col = jj;
				}
			}
			++insteadOfUsingCalcIndex;
		}
		insteadOfUsingCalcIndex -= (minOfSecondLoop + 1 - jjtemp) - dim;
	}

	if (filter) {
		// filter out min and max
		//optimisation: instead Of Using CalcIndex, we calculate it here
		num1 = min_row * dim + min_col;
		num2 = max_row * dim + max_col;
		
		
		//sum_pixels_by_weight(&sum, src[num1], -1);
		p = src[num1];
		redNum = sum.red;
		greenNum = sum.green;
		blueNum = sum.blue;
		redC = p.red;
		greenC = p.green;
		blueC = p.blue;
			
		redCnum = (int) redC;
		greenCnum = (int) greenC;
		blueCnum = (int) blueC;
			
		redNum -= redCnum;
		greenNum -= greenCnum;
		blueNum -= blueCnum;
			
		sum.red = redNum;
		sum.green = greenNum;
		sum.blue = blueNum;

		// sum_pixels_by_weight(&sum, src[num2], -1);

		p = src[num2];
		// redNum = sum.red;
		// greenNum = sum.green;
		// blueNum = sum.blue;
		redC = p.red;
		greenC = p.green;
		blueC = p.blue;
			
		redCnum = (int) redC;
		greenCnum = (int) greenC;
		blueCnum = (int) blueC;
			
		redNum -= redCnum;
		greenNum -= greenCnum;
		blueNum -= blueCnum;
			
		sum.red = redNum;
		sum.green = greenNum;
		sum.blue = blueNum;
	}

	// assign kernel's result to pixel at [i,j]
	//assign_sum_to_pixel(&current_pixel, sum, kernelScale);
	// optimisation: use instead of calling assign_sum_to_pixel we will do everyting it does here
	
	redNum = sum.red;
	greenNum = sum.green;
	blueNum = sum.blue;
	

    // divide by kernel's weight
	redNum = redNum / kernelScale;
	greenNum = greenNum / kernelScale;
	blueNum = blueNum / kernelScale;

	sum.red = redNum;
	sum.green = greenNum;
	sum.blue = blueNum;
	// optimisation: use local veriables to spare adressing to the register in stack
	//after calculation, we will change the value to the new value, for the register in stack
	char cRed, cGreen, cBlue;
	//optimisation: instead of calling max and min, we do, what these func does, here
	if(redNum < 0){
		redNum = 0;
	}
	if(redNum > 255){
		redNum = 255;
	}

	if(greenNum < 0){
		greenNum = 0;
	}
	if(greenNum > 255){
		greenNum = 255;
	}

	if(blueNum < 0){
		blueNum = 0;
	}
	if(blueNum > 255){
		blueNum = 255;
	}
	//redNum = max(redNum, 0);
	//redNum = min(redNum, 255);
	// greenNum = max(greenNum, 0);
	// greenNum =  min(greenNum, 255);
	// blueNum = max(blueNum, 0);
	// blueNum = min(blueNum, 255);

	cRed = (unsigned char) redNum;
	cGreen = (unsigned char) greenNum;
	cBlue = (unsigned char) blueNum;
	// truncate each pixel's color values to match the range [0,255]
	current_pixel.red = cRed ;
	current_pixel.green = cGreen;
	current_pixel.blue = cBlue;
	return current_pixel;
}

void doConvolution(Image *image, int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter) {
	int k = n;
	int h = k;
	Image image1 = *image;
	int row, col;
	//optimisation: doing calculation on local variables
	//n=m too
	k = k * k * sizeof(pixel);
	pixel* pixelsImg = malloc(k);
	pixel* backupOrg = malloc(k);
	unsigned char unChRed, unChGreen, unChBlue;
	//charsToPixels(image, pixelsImg);
	//optimisation: instead of calling charsToPixels, we do everyting it does, in this func
	int indexInPixels = 0, indexByThree; 
	//optimisation: stop adressing stack to check n's value
	// and n's value and m's value are the same
	//optimisation: instead of calling copyPixels, we do everyting it does, in this func, in the same loop
	int sizeOfPicture = n;
	for (row = 0 ; row < sizeOfPicture ; row++) {
		// optimisation: do calculation fewer times as possible
		//indexInPixels = row * sizeOfPicture;
		indexByThree = indexInPixels + indexInPixels + indexInPixels;
		for (col = 0 ; col < sizeOfPicture ; col++) {
			indexInPixels += col;
			unChRed = image1.data[indexByThree];
			//pixelsImg[indexInPixels].red = image1.data[indexByThree];
			++indexByThree;
			unChGreen = image1.data[indexByThree];
			//pixelsImg[indexInPixels].green = image1.data[indexByThree];
			++indexByThree;
			unChBlue = image1.data[indexByThree];
			//pixelsImg[indexInPixels].blue = image1.data[indexByThree];
			++indexByThree;
			pixelsImg[indexInPixels].red = unChRed;
			pixelsImg[indexInPixels].green = unChGreen;
			pixelsImg[indexInPixels].blue = unChBlue;

			backupOrg[indexInPixels].red = unChRed;
			backupOrg[indexInPixels].green = unChGreen;
			backupOrg[indexInPixels].blue = unChBlue;
			indexInPixels -= col;
		}
		indexInPixels += sizeOfPicture;
	}

	
	//smooth(h, backupOrg, pixelsImg, kernelSize, kernel, kernelScale, filter);
	//optimisation: instead of calling smooth, we do everyting it does, in this func
	int i, j;
	//optimisation: instead Of Using CalcIndex, we alculate it here
	int insteadOfUsingCalcIndex;
	//optimisation: instead Of calculating kernelSize / 2 twice we will clculate it once, with shifts
	int num = kernelSize >> 1;
	int d = h - num;
	//optimisation: instead Of Using CalcIndex, we alculate it here
	insteadOfUsingCalcIndex = num * h + num;
	for (i = num ; i < d; ++i) {
		for (j = num ; j < d ; ++j) {
			//optimisation: instead Of Using CalcIndex, we alculate it here
			pixelsImg[insteadOfUsingCalcIndex] = applyKernel(h, i, j, backupOrg, kernelSize, kernel, kernelScale, filter);
			++insteadOfUsingCalcIndex;
		}
		insteadOfUsingCalcIndex += num + num;
	}

	//pixelsToChars(pixelsImg, image);
	// optimisation: instead of calling pixelsToChars, we do what the func does, here
	//optimisation: stop adressing stack to check n's value
	// and n's value and m's value are the same

	// optimisation: do calculation fewer times as possible
	indexInPixels = 0;
	indexByThree = 0; 
	

	for (row = 0 ; row < sizeOfPicture ; ++row) {
		// optimisation: do calculation fewer times as possible
		// using + instead of *
		for (col = 0 ; col < sizeOfPicture ; ++col) {
			image->data[indexByThree] = pixelsImg[indexInPixels].red;
			++indexByThree;
			image->data[indexByThree] = pixelsImg[indexInPixels].green;
			++indexByThree;
			image->data[indexByThree] = pixelsImg[indexInPixels].blue;
			++indexByThree;
			++indexInPixels;
		}
	}
	free(pixelsImg);
	free(backupOrg);
}

void myfunction(Image *image, char* srcImgpName, char* blurRsltImgName, char* sharpRsltImgName, char* filteredBlurRsltImgName, char* filteredSharpRsltImgName, char flag) {

	/*
	* [1, 1, 1]
	* [1, 1, 1]
	* [1, 1, 1]
	*/
	int blurKernel[3][3] = {{1, 1, 1}, {1, 1, 1}, {1, 1, 1}};

	/*
	* [-1, -1, -1]
	* [-1, 9, -1]
	* [-1, -1, -1]
	*/
	int sharpKernel[3][3] = {{-1,-1,-1},{-1,9,-1},{-1,-1,-1}};

	if (flag == '1') {	
		// blur image
		doConvolution(image, 3, blurKernel, 9, false);

		// write result image to file
		writeBMP(image, srcImgpName, blurRsltImgName);	

		// sharpen the resulting image
		doConvolution(image, 3, sharpKernel, 1, false);
		
		// write result image to file
		writeBMP(image, srcImgpName, sharpRsltImgName);	
	} else {
		// apply extermum filtered kernel to blur image
		doConvolution(image, 3, blurKernel, 7, true);

		// write result image to file
		writeBMP(image, srcImgpName, filteredBlurRsltImgName);

		// sharpen the resulting image
		doConvolution(image, 3, sharpKernel, 1, false);

		// write result image to file
		writeBMP(image, srcImgpName, filteredSharpRsltImgName);	
	}
}

