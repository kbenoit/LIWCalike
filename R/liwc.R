#' analyze text in a LIWC-alike fashion
#'
#' Analyze a set of texts to produce a dataset of percentages and other
#' quantities describing the text, similar to the functionality supplied by the
#' Linguistic Inquiry and Word Count standalone software distributed at
#' \url{http://liwc.wpengine.com}.
#' @param x input object, a \pkg{quanteda} \link[quanteda]{corpus} or character
#'   vector for analysis
#' @param dictionary a \pkg{quanteda} \link[quanteda]{dictionary} object
#'   supplied for analysis
#' @param ... options passed to \code{\link[quanteda]{tokenize}} offering
#'   finer-grained control over how "words" are defined
#' @return a data.frame object containing the analytic results, one row per
#'   document supplied
#' @section Segmentation: The LIWC standalone software has many options for
#'   segmenting the text.  While this function does not supply segmentation
#'   options, you can easily achieve the same effect by converting the input
#'   object into a corpus (if it is not already a corpus) and using
#'   \link[quanteda]{changeunits} or \link[quanteda]{segment} to split the input
#'   texts into smaller units based on user-supplied tags, sentence, or
#'   paragraph boundaries.
#' @examples
#' liwcDict <- dictionary(file = "~/Dropbox/QUANTESS/dictionaries/LIWC/LIWC2015_English_Flat.dic",
#'                        format = "LIWC")
#' inaugLIWCanalysis <- liwc(inaugTexts, liwcDict)
#'
#' @export
liwc <- function(x, ...) {
    UseMethod("liwc")
}


#' @rdname liwc
#' @export
liwc.corpus <- function(x, ...) {
    liwc(texts(x), ...)
}

#' @rdname liwc
#' @export
liwc.character <- function(x, dictionary = NULL, toLower = TRUE, verbose = TRUE, ...) {

    ## initialize results data.frame
    ## similar to "Filename" and Segment
    result <-
        data.frame(docname = if (is.null(names(x))) paste0("text", 1:length(x)) else names(x),
                   Segment = 1:length(x),
                   stringsAsFactors = FALSE)

    ## get readability before lowercasing
    WPS <- readability(x, "meanSentenceLength", ...)

    ## lower case the texts if required
    if (toLower) x <- toLower(x)

    ## if a dictionary is supplied, apply it to the dfm
    # first pre-process the text for multi-word dictionary values
    if (!is.null(dictionary)) {
        x <- phrasetotoken(x, dictionary, case_insensitive = toLower)
        if (dictionary@concatenator != "_")
            dictionary <- lapply(dictionary, stringi::stri_replace_all_fixed, dictionary@concatenator, "_")
    }

    ## tokenize and form the dfm
    toks <- tokenize(x, ...)
    dfmAll <- dfm(toks, verbose = FALSE)
    if (!is.null(dictionary))
        dfmDict <- dfm(toks, verbose = FALSE, dictionary = dictionary)
        # or applyDictionary() to dfm

    ## WC
    result[["WC"]] <- ntoken(toks)
    # maybe this should be ntoken(dfmAll) - does LIWC count punctuation??

    ## no implementation for: Analytic	Clout	Authentic	Tone

    ## WPS (mean words per sentence)
    result[["WPS"]] <- WPS

    ## Sixltr
    result[["Sixltr"]] <- sapply(toks, function(y) sum(stringi::stri_length(y) > 6)) / result[["WC"]] * 100

    ## Dic (percentage of words in the dictionary)
    result[["Dic"]] <- if (!is.null(dictionary)) ntoken(dfmAll) / ntoken(dfmDict) * 100 else NA

    ## add the dictionary counts, transformed to percentages of total words
    if (!is.null(dictionary))
        result <- cbind(result,
                        as.data.frame(dfmDict / rep(result[["WC"]], each = nfeature(dfmDict)) * 100))

    ## add punctuation counts
    # AllPunc
    # Period
    # Comma
    # Colon
    # SemiC
    # QMark
    # Exclam
    # Dash
    # Quote
    # Apostro
    # Parenth -- note this is specified as "pairs of parentheses"
    # OtherP

    result
}


# the word counts

