#include <stdio.h>

#include <stdlib.h>

#include "config.h"

#include "constants.h"



void initParam();

void printParam();

int getLength(double arr[]);

void printArr(double arr[]);



void initParam()

{

	struct modelParam *ptr;

	ptr = (struct modelParam*) malloc(sizeof(modelParam));

	modelParam->diffCoef = diffCoef_C;

	modelParam->receptorDensity = receptorDensity_C;

	modelParam->aggregationDist = aggregationDist_C;

	modelParam->dissociationRate = dissociationRate_C;

	modelParam->labelRatio = labelRatio_C;



}



void printParam()

{

	printf("modelParam: \n");

	printf("diffCoef: %f\n", diffCoef);

	printf("receptorDensity: %f\n", receptorDensity);

	printf("aggregationDist: %f\n", aggregationDist);

	printf("dissociationRate: %f\n", dissociationRate);

	printf("labelRatio: %f\n", labelRatio);

	/*

	printArr(aggregationProb);

	printArr(intensityQuantum);

	printArr(initPositions);

	*/

	printf("-----------------------------------------");

}



int getLength(double arr[])

{

	return (int)(sizeof(arr) / sizeof(arr[0]));

}



void printArr(double arr[])

{

	printf("%s: [", getName(arr));

	for(int i = 0; i < getLength(arr); i++){

		printf("%f ", arr[i]);

	}

	printf("]\n");

}



int main()

{

	initParam();

	printParam();

	return 0;

}
