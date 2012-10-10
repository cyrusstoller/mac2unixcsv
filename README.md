# Mac2UnixCSV

I was processing some csv files recently and was having a hard time parsing them with my favorite UNIX tools like `awk`, `cat`, `head`, `tail`, `less`, and `sed`. So, I wrote this little script to convert csv files output by Excel so that they're more friendly to work with.

## Usage

```
$ ruby mac2unixcsv.rb INFILE OUTFILE
```