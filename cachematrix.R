##-------------R Programming Assigment Week2-------
## The "makeCacheMatrix" function takes a square matrix as input,
## computes and caches its own inverse
## output is used as input into the next function "CacheSolve"

makeCacheMatrix <- function(x = matrix()) {
                invmatrix<-NULL
                
                set<-function(y){
                        x <<- y # <<- is used to assign value in parent environment
                        invmatrix <<- NULL
                }
                get<-function() x
                
                setinvmatrix <- function(solve) invmatrix <<- solve
                getinvmatrix <- function() invmatrix
                
                list(set=set,  get=get,
                     setinvmatrix=setinvmatrix,
                     getinvmatrix=getinvmatrix)
        }



# This function computes the inverse of a given matrix.
# it first checks if the inverse is already cached in parent
# environment. If yes, cached value is retrieved
# if not computes inverse value.

cacheSolve <- function(x, ...) {        # takes output of makeCacheMatrix()
        invmatrix<-x$getinvmatrix() 
        if(!is.null(invmatrix)){        # checks existence of inverse
                message("getting cached data")
                return(invmatrix)       # returns existing inverse of x
        }
        
        # otherwise this section computes the inverse matrix
        matrix<-x$get()
        invmatrix <- solve(matrix, ...)
        x$setinvmatrix(invmatrix)
        invmatrix
        
}
