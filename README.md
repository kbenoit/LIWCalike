**Master branch** \[![Build Status](https://travis-ci.org/kbenoit/LIWCalike.svg?branch=master)\]\[![codecov.io](https://codecov.io/github/kbenoit/LIWCalike/coverage.svg?branch=master)\](<https://codecov.io/github/kbenoit/LIWCalike/coverage.svg?branch=master>)

LIWCalike: an R implementation of the Linguistic Inquiry and Word Count
-----------------------------------------------------------------------

Built on the quanteda package for text analysis, LIWCalikes provides a simple interface to the analysis of text by counting words and other textual features, including the application of a dictionary to produce a tabular report of percentages. This provides similar functionality to the LIWC stand-alone software. The user must a dictionary, which can include one of the custom LIWC dictionaries if these have been purchased from <http://liwc.wpengine.com>, or any other dictionary supplied by the user.

### Differences from the LIWC standalone software

This package is designed for R users and those wishing to build functionality by extending the [**quanteda**](https://github.com/kbenoit/quanteda) package for text analysis. If you prefer to have a complete, stand-alone user interface, then you should purchase and use the [LIWC standalone software](http://liwc.wpengine.com). This has several advantages:

-   LIWC allows direct importing of files, including binary (Word, pdf, etc) formats. To use **LIWCalike**, you will need to import these into the **quanteda** package first.
    **LIWCalike** also works fine with simple character vectors, if you prefer to use standard R methods to create your input object (e.g. `readLines()`, `read.csv()`, etc.)

-   LIWC provides direct outputs in the form of csv, Excel files, etc. By contrast, **LIWCalike** returns a `data.frame`, which you have to export yourself (e.g. using `write.csv()`.)

-   LIWC provides easy segmentation, through a GUI. By contrast, with **LIWCalike** you will have to segment the texts yourself. (**quanteda** provides easy ways to do this using `segment()` and `changeunits()`.)

-   LIWC color codes the dictionary value matches in your texts and displays these in a nice graphical window.

Using dictionaries with LIWCalike
---------------------------------

No dictionaries are supplied with **LIWCalike**, it is up to you to supply these. With the **quanteda** functions for creating or importing dictionaries, however, this is quite easy.

With the LIWC 2007, external dictionaries were distributed with the software that could be used in the format read by Provalis Research's [*Wordstat*](http://provalisresearch.com/products/content-analysis-software/). Because I purchases a license for this product, I have that file and can use it with **LIWCalike**.

Using it is quite straightforward:

``` r
require(LIWCalike)
#> Loading required package: LIWCalike
#> Loading required package: quanteda
#> quanteda version 0.9.5.20
#> 
#> Attaching package: 'quanteda'
#> The following object is masked from 'package:base':
#> 
#>     sample

# read in the dictionary
liwc2007dict <- dictionary(file = "~/Dropbox/QUANTESS/dictionaries/LIWC/LIWC2007.cat", 
                           format = "wordstat")
#> Warning in strsplit(w, "\\("): input string 1 is invalid in this locale
tail(liwc2007dict, 1)
#> $`SPOKEN CATEGORIES.FILLERS`
#>  [1] "blah"         NA             "idontknow"    "imean"       
#>  [5] "ohwell"       "oranything*"  "orsomething*" "orwhatever*" 
#>  [9] "rr*"          "yakn*"        "ykn*"         "youknow*"

# our test data
testphrases
#>  [1] "Test sentence for LIWCalike.  Second sentence."                   
#>  [2] "Each row is a document."                                          
#>  [3] "Comma, period."                                                   
#>  [4] "The red-shirted lawyer gave her ex-boyfriend $300 out of pity :(."
#>  [5] "LOL :-)."                                                         
#>  [6] "(Parentheses) for $100."                                          
#>  [7] "Say \"what\" again!!"                                             
#>  [8] "Why are we here?"                                                 
#>  [9] "Other punctation: §; ±."                                          
#> [10] "Sentence one.  Sentence two! :-)"

# call LIWCalike
output <- liwcalike(testphrases, liwc2007dict)

# view some results
output[, c(1:7, ncol(output)-2)]
#>        docname Segment WC WPS Sixltr    Dic
#> text1    text1       1  6   3  50.00 120.00
#> text2    text2       2  5   5  20.00  50.00
#> text3    text3       3  2   2   0.00 100.00
#> text4    text4       4 12  12  16.67  40.00
#> text5    text5       5  1   1   0.00  33.33
#> text6    text6       6  3   3  33.33  75.00
#> text7    text7       7  3   3   0.00  30.00
#> text8    text8       8  4   4   0.00  26.67
#> text9    text9       9  2   2  50.00  66.67
#> text10  text10      10  4   2  50.00 100.00
#>        LINGUISTIC PROCESSES.FUNCTION WORDS SPOKEN CATEGORIES.ASSENT
#> text1                                33.33                        0
#> text2                                50.00                        0
#> text3                                 0.00                        0
#> text4                                66.67                        0
#> text5                                 0.00                       25
#> text6                                16.67                        0
#> text7                                33.33                        0
#> text8                                50.00                        0
#> text9                                16.67                        0
#> text10                               33.33                        0
```

How to Install
--------------

    devtools::install_github("kbenoit/quanteda")
    devtools::install_github("kbenoit/LIWCalike")

You need to have installed the **quanteda** package of at least version 0.9.5-20 for this to work, since that update implemented multi-word dictionary values.

Comments and feedback
---------------------

I welcome your comments and feedback. Please file issues on the issues page, and/or send me comments at <kbenoit@lse.ac.uk>.
