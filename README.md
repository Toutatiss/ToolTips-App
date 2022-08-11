# ToolTips-App
An iPhone application written in Swift.

The ToolTips app is a small proof-of-concept app that makes use of AWS EC2 to process CNC milling machine data in order to predict when the tool bit will wear out.
The Firebase SDK has been included in this app to host a realtime database that is written to by the EC2 server. The app graphically displays the prediction pattern calculated for a fixed set of machine parameter configurations.

![image7](https://user-images.githubusercontent.com/48107965/184076534-5af92f9a-3ae6-478c-a8ca-05f46509185f.gif)
