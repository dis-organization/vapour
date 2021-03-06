% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vapour_input_geometry.R
\name{vapour_read_geometry}
\alias{vapour_read_geometry}
\alias{vapour_read_geometry_text}
\alias{vapour_read_extent}
\title{Read GDAL feature geometry}
\usage{
vapour_read_geometry(
  dsource,
  layer = 0L,
  sql = "",
  limit_n = NULL,
  skip_n = 0,
  extent = NA
)

vapour_read_geometry_text(
  dsource,
  layer = 0L,
  sql = "",
  textformat = "json",
  limit_n = NULL,
  skip_n = 0,
  extent = NA
)

vapour_read_extent(
  dsource,
  layer = 0L,
  sql = "",
  limit_n = NULL,
  skip_n = 0,
  extent = NA
)
}
\arguments{
\item{dsource}{data source name (path to file, connection string, URL)}

\item{layer}{integer of layer to work with, defaults to the first (0) or the name of the layer}

\item{sql}{if not empty this is executed against the data source (layer will be ignored)}

\item{limit_n}{an arbitrary limit to the number of features scanned}

\item{skip_n}{an arbitrary number of features to skip}

\item{extent}{apply an arbitrary extent, only when 'sql' used (must be 'ex = c(xmin, xmax, ymin, ymax)' but sp bbox, sf bbox, and raster extent also accepted)}

\item{textformat}{indicate text output format, available are "json" (default), "gml", "kml", "wkt"}
}
\description{
Read GDAL geometry as binary blob, text, or numeric extent.
}
\details{
\code{vapour_read_geometry} will read features as binary WKB, \code{vapour_read_geometry_text} as various text formats (geo-json, wkt, kml, gml),
\code{vapour_read_extent} a numeric extent which is the native bounding box, the four numbers (in this order) \verb{xmin, xmax, ymin, ymax}.
For each function an optional SQL string will be evaluated against the data source before reading.

\code{vapour_read_geometry_cpp} will read a feature for each of the ways listed above and is used by those functions. It's recommended
to use the more specialist functions rather than this more general one.

Note that \code{limit_n} and \code{skip_n} interact with the affect of \code{sql}, first the query is executed on the data source, then
while looping through available features \code{skip_n} features are ignored, and then a feature-count begins and the loop
is stopped if \code{limit_n} is reached.

Note that \code{extent} applies to the 'SpatialFilter' of 'ExecuteSQL': https://gdal.org/user/ogr_sql_dialect.html#executesql.
}
\examples{
file <- "list_locality_postcode_meander_valley.tab"
## A MapInfo TAB file with polygons
mvfile <- system.file(file.path("extdata/tab", file), package="vapour")
## A shapefile with points
pfile <- system.file("extdata/point.shp", package = "vapour")

## raw binary WKB points in a list
ptgeom <- vapour_read_geometry(pfile)
## create a filter query to ensure data read is small
SQL <- "SELECT FID FROM list_locality_postcode_meander_valley WHERE FID < 3"
## polygons in raw binary (WKB)
plgeom <- vapour_read_geometry_text(mvfile, sql = SQL)
## polygons in raw text (GeoJSON)
txtjson <- vapour_read_geometry_text(mvfile, sql = SQL)

## polygon extents in a list xmin, xmax, ymin, ymax
exgeom <- vapour_read_extent(mvfile)

## points in raw text (GeoJSON)
txtpointjson <- vapour_read_geometry_text(pfile)
## points in raw text (WKT)
txtpointwkt <- vapour_read_geometry_text(pfile, textformat = "wkt")
}
