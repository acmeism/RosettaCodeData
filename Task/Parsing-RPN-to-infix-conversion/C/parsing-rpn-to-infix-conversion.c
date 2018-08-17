#include<stdlib.h>
#include<string.h>
#include<stdio.h>

char** components;
int counter = 0;

typedef struct elem{
	char data[10];
	struct elem* left;
	struct elem* right;
}node;

typedef node* tree;

int precedenceCheck(char oper1,char oper2){
	return (oper1==oper2)? 0:(oper1=='^')? 1:(oper2=='^')? 2:(oper1=='/')? 1:(oper2=='/')? 2:(oper1=='*')? 1:(oper2=='*')? 2:(oper1=='+')? 1:(oper2=='+')? 2:(oper1=='-')? 1:2;
}

int isOperator(char c){
	return (c=='+'||c=='-'||c=='*'||c=='/'||c=='^');
}

void inorder(tree t){
	if(t!=NULL){
		if(t->left!=NULL && isOperator(t->left->data[0])==1 && (precedenceCheck(t->data[0],t->left->data[0])==1 || (precedenceCheck(t->data[0],t->left->data[0])==0 && t->data[0]=='^'))){
			printf("(");
			inorder(t->left);
			printf(")");
		}
		else
			inorder(t->left);
	
		printf(" %s ",t->data);
	
		if(t->right!=NULL && isOperator(t->right->data[0])==1 && (precedenceCheck(t->data[0],t->right->data[0])==1 || (precedenceCheck(t->data[0],t->right->data[0])==0 && t->data[0]!='^'))){
			printf("(");
			inorder(t->right);
			printf(")");
		}
		else
			inorder(t->right);
	}
}

char* getNextString(){
	if(counter<0){
		printf("\nInvalid RPN !");
		exit(0);
	}
	return components[counter--];
}

tree buildTree(char* obj,char* trace){
	tree t = (tree)malloc(sizeof(node));
	
	strcpy(t->data,obj);
	
	t->right = (isOperator(obj[0])==1)?buildTree(getNextString(),trace):NULL;
	t->left = (isOperator(obj[0])==1)?buildTree(getNextString(),trace):NULL;
	
	if(trace!=NULL){
			printf("\n");
			inorder(t);
	}

	return t;
}

int checkRPN(){
	int i, operSum = 0, numberSum = 0;
	
	if(isOperator(components[counter][0])==0)
		return 0;
	
	for(i=0;i<=counter;i++)
		(isOperator(components[i][0])==1)?operSum++:numberSum++;

	return (numberSum - operSum == 1);
}

void buildStack(char* str){
	int i;
	char* token;
	
	for(i=0;str[i]!=00;i++)
		if(str[i]==' ')
			counter++;
		
	components = (char**)malloc((counter + 1)*sizeof(char*));
	
	token = strtok(str," ");
	
	i = 0;
	
	while(token!=NULL){
		components[i] = (char*)malloc(strlen(token)*sizeof(char));
		strcpy(components[i],token);
		token = strtok(NULL," ");
		i++;
	}
}

int main(int argC,char* argV[]){
	int i;
	tree t;
	
	if(argC==1)
		printf("Usage : %s <RPN expression enclosed by quotes> <optional parameter to trace the build process>",argV[0]);
	else{
		buildStack(argV[1]);
		
		if(checkRPN()==0){
			printf("\nInvalid RPN !");
			return 0;
		}
		
		t = buildTree(getNextString(),argV[2]);
		
		printf("\nFinal infix expression : ");
		inorder(t);
	}
	
	return 0;
}
