How to run:
cd to the location of your heap dump file, then:
```docker run --mount src=$(pwd),target=/data,type=bind -it auto-mat:1.0 <dump filename> <heap size for mat>```

Example:

docker run -it --mount src=$(pwd),target=/data,type=bind auto-mat:1.0 heap1 11g

How to build:

```docker build . -t auto-mat:1.0```