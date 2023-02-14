# create log file
# If you use this command (sink), all results will be stored in log file but not showed up in the Console
#sink("D:\\nest\\Dropbox\\causal_data_course\\2018_spring\\Class_Data\\R_code\\R_log\\C0_log.txt")

1 + 1
2^3
log(exp(sin(pi/4)^2) * exp(cos(pi/4)^2))



# Objects can easily be created by assigning a value to a name, using the assignment operator <-
# Creating objects
x <- 2
x

y = 3
y

# The function log() has two arguments, x (a numeric scalar or vector), base (the base with respect to which logarithms are computed)
a <-log(x = 16, base = 2)
a

b <-log(16, 2)
b

z <- c(1.8, 3.14, 4, 88.169, 13)
z
Z

h <- seq(from = 2, to = 20, by = 2)
h

trend <- 1981:2005
trend

u <- c(z,h,x)
u

x1 <-  2*x + 3
x2 <-  1:5 * x + 5:1
log_x <-  log(x)




# Subsets of vectors: Operator [ can be used in several ways.
z1 <- z[c(1, 4)]
z1

z2 <- z[-c(2, 3, 5)]
z2


# Matrix operations
A <- matrix(1:6, nrow = 2)
A

B<-matrix(1:6, ncol = 3)
B

t(A)
nrow(A)
ncol(A)
dim(A)

A1 <- A[1:2, c(1, 3)]
A[, -2]





# List all objects in the global environment (i.e., the user¡¦s workspace)
objects()


# display the length of object
length(z)


# Every object has a class that can be queried using class()
# For each class, certain methods to generic functions can be available
class(A)
class(z)

# Removing objects with remove() or rm()
remove(x)

objects()



# install packages
install.packages(c("ggplot2", "foreign"))
install.packages("ggplot2")
install.packages("foreign")


# load library
library(foreign)
library(ggplot2)

# The help page for any function or data set can be accessed using either ? or help()
?lm
??lm
help("lm")

# At the bottom of a help page, there are typically practical examples of how to use that function. These can easily be executed:
example("lm")

# If the exact name of a command is not known, the functions to use are
help.search("linear")
apropos("lm")


# A demo is an interface to run some demonstration R scripts.
demo("graphics")






