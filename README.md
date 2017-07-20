# Quick-Intro-R-Drug-Development by Phil Bowsher on Thur, May 14th, 2017

Live Presentation is here:

https://beta.rstudioconnect.com/content/2759/#1

Other apps and reports are here:

Starbucks:

https://beta.rstudioconnect.com/content/2760/viewer-rpubs-774073c8e465.html

Basic Shiny:

https://beta.rstudioconnect.com/content/2761/

Interactive Plot:

https://beta.rstudioconnect.com/content/2763/

Flex ToothGrowth:

https://beta.rstudioconnect.com/content/2765/Flex_No_Shiny_ToothGrowth.html

Shiny Plots ToothGrowth:

https://beta.rstudioconnect.com/content/2766/

Flex Shiny:

https://beta.rstudioconnect.com/content/2767/

Crosstalk:

https://beta.rstudioconnect.com/content/2768/crosstalk_toothgrowth.html

IMMUNOGENICITY App:

https://beta.rstudioconnect.com/content/2769/

IMMUNOGENICITY website:

https://beta.rstudioconnect.com/content/2770/

IMMUNOGENICITY HTML Template:

https://beta.rstudioconnect.com/content/2771/

IMMUNOGENICITY Book Tech Document:

https://beta.rstudioconnect.com/content/2899/

Presentations and code from workshop.

Requires the following packages from CRAN:

```r
install.packages(c("leaflet", "shiny", "shinydashboard", "rmarkdown", "flex_dashboard", "ggplot2", "plotly", "plyr", "reshape2"))
``` 

To access to the OpenFDA API from R, which uses the jsonlite and magrittr packages, you'll need the devtools package to install it as the library has not yet been added to CRAN, so follow these steps:

```r
install.packages("devtools")
```

Once devtools is installed, you can grab this package:

```r
library("devtools")
devtools::install_github("ropenhealth/openfda")
```
Load it in like any other package:

```r
library("openfda")
```

An up-to-date version of RStudio is also recommended.

R 3.2.5 used for examples.

Links/examples reviewed in the following order:

## **Shiny**

http://shiny.rstudio.com/

    A web application framework for R.

## **R Markdown**

http://rmarkdown.rstudio.com/
  
    R Markdown provides an authoring framework for data science and documents are fully reproducible and support dozens of static and dynamic output formats.

## **HTML Widgets**

http://www.htmlwidgets.org/

    R bindings to JavaScript libraries.
    
## **Applications in Drug Development**

    Live apps, analysis, tools and research.