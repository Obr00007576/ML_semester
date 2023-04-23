# ML_semester
ML_semester

My work is to deal with the dataset: SPECT
## Work1
The 3 classification methods I choose are: decision tree, svm, adaboost.

For decision tree, the best model is the original one without pruned.

Error rate:
```
[1] "Error rate:  0.240641711229947"
```

For adaboost, the best model is with 221 tree models.

Error rate:
```
[1] "The cost with minimum:  221 Min value:  0.197860962566845"
```

For svm, the best model is set with parameters: cost = , kernel = radial

Error rate:
```
[1] "The cost with minimum:  0.1 Min value:  0.144385026737968"
```

I used perplexity = 1, 4, 6 to draw the tnse images:
![avatar](tsne_1.png)
![avatar](tsne_4.png)
![avatar](tsne_6.png)

## Work2
The model with least error rate is svm.
