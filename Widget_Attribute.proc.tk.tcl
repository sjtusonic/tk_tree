proc Widget_Attribute {w {out stdout}} {
   puts $out [format "%-20s %-10s %s" Attribute Default Value]
   puts "$w configure"
   foreach item [$w configure] {
      puts $out [format "%-20s %-10s %s"  \
         [lindex $item 0] [lindex $item 3] \
         [lindex $item 4] ]
   }
}

# test:
if {0} {
   source  example.21-1.tcl
   Widget_Attribute .hello
}
