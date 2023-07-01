#include <stdio.h>
#include <stdlib.h>



int number_of_digits(int x){
    int NumberOfDigits;
    for(NumberOfDigits=0;x!=0;NumberOfDigits++){
        x=x/10;
    }
    return NumberOfDigits;
}

int* convert_array(char array[], int NumberOfElements)  //converts integer arguments from char to int
{
    int *convertedArray=malloc(NumberOfElements*sizeof(int));
    int originalElement, convertedElement;

    for(convertedElement=0, originalElement=0; convertedElement<NumberOfElements; convertedElement++)
    {
       convertedArray[convertedElement]=atoi(&array[originalElement]);
       originalElement+=number_of_digits(convertedArray[convertedElement])+1; //computes where is the beginning of the next element

    }
    return convertedArray;
}



int isSorted(int array[], int numberOfElements){
    int sorted=1;
    for(int counter=0;counter<numberOfElements;counter++){
        if(counter!=0 && array[counter-1]>array[counter]) sorted--;

    }
    return sorted;
}
int main(int argc, char* argv[])
{
    int* convertedArray;


    convertedArray=convert_array(*(argv+1), argc-1);



    if(isSorted(convertedArray, argc-1)==1) printf("Did you forgot to turn on your brain?! This array is already sorted!\n");
    else if(argc-1<=10) printf("Am I really supposed to sort this? Sort it by yourself!\n");
    else printf("Am I really supposed to sort this? Bhahahaha!\n");
    free(convertedArray);
    return 0;



}
