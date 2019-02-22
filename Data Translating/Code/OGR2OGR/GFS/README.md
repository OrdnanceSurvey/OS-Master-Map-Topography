# GFS Files

GFS files help OGR2OGR understand the structure of a GML file. If you do not provide one during translation then OGR2OGR will create one on the fly for each GML file it is translating. Sometimes this is successful othertimes depending on the structure of the GML file OGR2OGR fails to pick up important attributes as they are in part of the GML tree that it has not read.

As a result it is always useful to get OGR2OGR to create an inital GFS file and then review its contents to make sure it is picking up the full structure of the file you need. One way to get OGR2OGR to create a GFS file is to run the following command:

`ogrinfo -ro -so -al /vsigzip/path_to_gzipfile.gz`

This will create a GFS file in the directory.

[Matt Walker](https://github.com/walkermatt), from Astun Technology, has a full list of OGR2OGR GFS Geometry Types which is very useful and can be found [here](https://gist.github.com/walkermatt/7121427).

