#
# multicolumn-rankorder-slopegraph.R
#
# 2013-01-12 - formatting tweaks
# 2013-01-10 - Initial version - boB Rudis - @hrbrmstr
#
# Pretty much explained by the script title. This is an R script which is designed to produce
# 2+ column rank-order slopegraphs with the ability to highlight meaningful patterns
#
 
library(ggplot2)
library(reshape2)
 
# transcription of table from:
# http://blogs.technet.com/b/security/archive/2013/01/07/operating-system-infection-rates-the-most-common-malware-families-on-each-platform.aspx
#
# You can download it from: 
# https://docs.google.com/spreadsheet/ccc?key=0AlCY1qfmPPZVdHpwYk0xYkh3d2xLN0lwTFJrWXppZ2c
 
df = read.csv("~/Desktop/subjects/truman1.csv")
 
# For this slopegraph, we care that #1 is at the top and that higher value #'s are at the bottom, so we 
# negate the rank values in the table we just read in
 
# df$Rank.Win7.SP1 = -df$Rank.Win7.SP1
# df$Rank.Win7.RTM = -df$Rank.Win7.RTM
# df$Rank.Vista = -df$Rank.Vista
# df$Rank.XP = -df$Rank.XP
 
# Also, we are really comparing the end state (ultimately) so sort the list by the end state.
# In this case, it's the Windows 7 malware data.
 
df$Major.Subject = with(df, reorder(Major.Subject, X1948))
 
# We need to take the multi-columns and make it into 3 for line-graph processing 
 
dfm = melt(df)
 
# We need to take the multi-columns and make it into 3 for line-graph processing 
 
dfm = melt(df)
 
# We define our color palette manually so we can highlight the lines that "matter".
# This means you'll need to generate the slopegraph at least one time prior to determine
# which lines need coloring. This should be something we pick up algorithmically, eventually
 
sgPalette = c("#990000", "#990000",  "#CCCCCC", "#CCCCCC", "#CCCCCC","#CCCCCC", "#990000", "#CCCCCC", "#CCCCCC", "#CCCCCC", "#CCCCCC", "#CCCCCC", "#CCCCCC", "#CCCCCC", "#CCCCCC",  "#CCCCCC", "#CCCCCC",  "#CCCCCC", "#CCCCCC")
#sgPalette = c("#CCCCCC", "#CCCCCC",  "#CCCCCC", "#CCCCCC", "#CCCCCC","#CCCCCC", "#CCCCCC", "#CCCCCC", "#CCCCCC", "#CCCCCC", "#CCCCCC", "#CCCCCC", "#CCCCCC", "#CCCCCC", "#CCCCCC")
#sgPalette = c("#000000", "#000000",  "#000000", "#000000", "#000000","#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000")
 
 
# start the plot
#
# we do a ton of customisations to the plain ggplot canvas, but it's not rocket science
 
sg = ggplot(dfm, aes(factor(variable), value, 
                     group = Major.Subject, 
                     colour = Major.Subject, 
                     label = Major.Subject)) +
  scale_colour_manual(values=sgPalette) +
  theme(legend.position = "none", 
        axis.text.x = element_text(size=5),
        axis.text.y=element_blank(), 
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.ticks=element_blank(),
        axis.line=element_blank(),
        panel.grid.major = element_line("black", size = 0.1),
        panel.grid.major = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.background = element_blank())
 
# plot the right-most labels
 
sg1 = sg + geom_line(size=0.15) + 
  geom_text(data = subset(dfm, variable == "X1948"), 
            aes(x = factor(variable), label=sprintf(" %f %s",(value),Major.Subject)), size = 1.75, hjust = 0) 
 
# plot the left-most labels
 
sg1 = sg1 + geom_text(data = subset(dfm, variable == "X1946"), 
                     aes(x = factor(variable), label=sprintf("%s %f ",Major.Subject,(value))), size = 1.75, hjust = 1)
 
# this ratio seems to work well for png output
# you'll need to tweak font size for PDF output, but PDF will make post-processing in 
# Illustrator or Inkscape much easier.
 
ggsave("~/Desktop/Truman1.pdf",sg1,w=8,h=10,dpi=150)
