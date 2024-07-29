
library("NMOF")
################################
testFun <- function(x){
liste <-c(x[1L],x[2L],x[3L])
   return(liste)
}
par1 <- c(0.1,0.2)
par2 <- c(0.1,0.2)
par3 <- c(1)
sol <- gridSearch(fun = testFun, levels = list(par1, par2,par3))
sol$minfun
sol$minlevels
################################################
#find similarity between comment and code files
library("stringdist")
library("stringi")
library("tensorflow")
library("keras")
library("tm")
rl <- readLines("D:/makaleler/commentInconsistency/dataset/TL-CodeSum/commentTrain.txt")
rl2 <- readLines("D:/makaleler/commentInconsistency/dataset/TL-CodeSum/codeTrain.txt")
rl3 <- readLines("D:/makaleler/commentInconsistency/dataset/TL-CodeSum/commentValid.txt")
trim.leading <- function (x)  sub("^\\s+", "", x)
###11.03.2024 tarihinde "rl" ile ultimate yer degistirildi
rl <- trim.leading(rl)
rl2 <- trim.leading(rl2)
rl<-removePunctuation(rl)
rl2<-removePunctuation(rl2)
rl3<-removePunctuation(rl3)
rl <- as.character(stri_remove_empty(rl, na_empty = FALSE))
rl2 <- as.character(stri_remove_empty(rl2, na_empty = FALSE))
rl3 <- as.character(stri_remove_empty(rl3, na_empty = FALSE))
trim.leading <- function (x)  sub("^\\s+", "", x)
rl3 <- trim.leading(rl3)
##two vectors must be the same length
rl2 <- rl2[1:length(rl)]
i <- 1
labelVector <- numeric()
while(i<=length(rl))
{
	if(!is.na(rl2[i]) && !is.na(rl[i]))
	sonuc <- stringsim(rl[i],rl2[i],method='jw', p=0.1)
	if(sonuc >= 0.5)
		labelVector <- append(labelVector,1)
	else
	labelVector <- append(labelVector,0)
	i <- i+1
}
##############################################
######################TRAIn
rl <- readLines("D:/makaleler/commentInconsistency/dataset/TL-CodeSum/commentTrain.txt")
#Bu satır eklenmeden kod çalışmıyor ihtimal parametreler ile ilgili
text <- rl

max_features <- 1000
tokenizer <- text_tokenizer(num_words = max_features)


tokenizer %>% 
  fit_text_tokenizer(text)

text_seqs <- texts_to_sequences(tokenizer, text)

# Set parameters:
maxlen <- 100
batch_size <- 32
embedding_dims <- 50
filters <- 64
kernel_size <- 3
hidden_dims <- 50



x_train <- text_seqs %>%
  pad_sequences(maxlen = maxlen)
dim(x_train)


y_train <- labelVector

epochs <- 2


i <- 1
j <- 2
k <- 3
sonucList <- c()
sonucList2 <- c()
sonucList3 <- c()
sonucList4 <- c()
xL <- length(sol$values)
while(i<xL){
model <- keras_model_sequential() %>% 
  layer_embedding(max_features, embedding_dims, input_length = maxlen) %>%
  layer_dropout(sol$values[i]) %>%
  layer_conv_1d(
    filters, kernel_size, 
    padding = "valid", activation = "relu", strides = 1
  ) %>%
  layer_global_max_pooling_1d() %>%
  layer_dense(hidden_dims) %>%
  layer_dropout(sol$values[j]) %>%
  layer_activation("relu") %>%
  layer_dense(sol$values[k]) %>%
  layer_activation("sigmoid") %>% compile(
  loss = "binary_crossentropy",
  optimizer = "adam",
  metrics = "accuracy"
)
hist <- model %>%
  fit(
    x_train,
    y_train,
    batch_size = batch_size,
    epochs = epochs,
    validation_split = 0.3
  )




score <- model %>% evaluate(
  x_train, y_train,
  steps = 10,
  batch_size = batch_size,
  verbose = 1
)

sonucList <- append(sonucList,score)
sonucList2 <- append(sonucList2,sol$values[i])
sonucList3 <- append(sonucList3,sol$values[j])
sonucList4 <- append(sonucList4,sol$values[k])
i <- i+3
j <- j+3
k <- k+3
#############################
}


