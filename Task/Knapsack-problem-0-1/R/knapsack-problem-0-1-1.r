Full_Data<-structure(list(item = c("map", "compass", "water", "sandwich",
"glucose", "tin", "banana", "apple", "cheese", "beer", "suntan_cream",
"camera", "T-shirt", "trousers", "umbrella", "waterproof_trousers",
"waterproof_overclothes", "note-case", "sunglasses", "towel",
"socks", "book"), weigth = c(9, 13, 153, 50, 15, 68, 27, 39,
23, 52, 11, 32, 24, 48, 73, 42, 43, 22, 7, 18, 4, 30), value = c(150,
35, 200, 160, 60, 45, 60, 40, 30, 10, 70, 30, 15, 10, 40, 70,
75, 80, 20, 12, 50, 10)), .Names = c("item", "weigth", "value"
), row.names = c(NA, 22L), class = "data.frame")


Bounded_knapsack<-function(Data,W)
{
	K<-matrix(NA,nrow=W+1,ncol=dim(Data)[1]+1)
	0->K[1,]->K[,1]
	matrix_item<-matrix('',nrow=W+1,ncol=dim(Data)[1]+1)
	for(j in 1:dim(Data)[1])
	{
		for(w in 1:W)
		{
			wj<-Data$weigth[j]
			item<-Data$item[j]
			value<-Data$value[j]
			if( wj > w )
			{
				K[w+1,j+1]<-K[w+1,j]
				matrix_item[w+1,j+1]<-matrix_item[w+1,j]
			}
			else
			{
				if( K[w+1,j] >= K[w+1-wj,j]+value )
				{
					K[w+1,j+1]<-K[w+1,j]
					matrix_item[w+1,j+1]<-matrix_item[w+1,j]					
				}
				else
				{
					K[w+1,j+1]<-K[w+1-wj,j]+value
					matrix_item[w+1,j+1]<-item
				}
			}
		}
	}
return(list(K=K,Item=matrix_item))
}

backtracking<-function(knapsack, Data)
{
	W<-dim(knapsack$K)[1]
	itens<-c()
	col<-dim(knapsack$K)[2]
	selected_item<-knapsack$Item[W,col]
	while(selected_item!='')
	{
		selected_item<-knapsack$Item[W,col]
		if(selected_item!='')
		{
			selected_item_value<-Data[Data$item == selected_item,]
			if(-knapsack$K[W - selected_item_value$weigth,col-1]+knapsack$K[W,col]==selected_item_value$value)
			{
				W <- W - selected_item_value$weigth
				itens<-c(itens,selected_item)
			}
			col <- col - 1
		}
	}
return(itens)
}

print_output<-function(Data,W)
{
	Bounded_knapsack(Data,W)->Knap
	backtracking(Knap, Data)->Items
	output<-paste('You must carry:', paste(Items, sep = ', '), sep=' ' )
	return(output)
}

print_output(Full_Data, 400)
