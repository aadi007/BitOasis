# Real Time Exchange Data Display
Display Real time Data 

Functions involved here are:
1) Login and sign up feature:
* Email login is supported 
* Firebase data store is used
* if the user is not registered it creates the user and logs in
2) Websocket is created to fetch the ticker data and display in the linear graph
* connection is made
* data is parsed and shown in graph
* X axis: currency Pair
* Y axis: Last trade price
![simulator screen shot - iphone x - 2019-02-01 at 22 01 23](https://user-images.githubusercontent.com/9161270/52140725-ef064600-266c-11e9-9a81-4b5352918c35.png)
3) Filter the results to display the highs and low with the user input
* you can insert a value in the text field and filter the graph
* highs are denoted by green
* lows are denoted by Red
4) By default the view is Linear but with the help of the switch user can view in different view
* Bar graph view
* filter support is added to bar graph as well
![simulator screen shot - iphone x - 2019-02-01 at 22 00 39](https://user-images.githubusercontent.com/9161270/52140700-d85fef00-266c-11e9-9628-118b3de4b62a.png)
