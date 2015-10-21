#!/usr/loca/bin/wish
source ../small_lib/include.tcl
source Widget_Attribute.proc.tk.tcl

set OFFSET_X 1.0
set OFFSET_Y 0.2
#return
package require Tk
#button .hello -text Hello \
#   -command {puts stdout "Hello, World!"}
#pack .hello -padx 20 -pady 10


set w .items
catch {destroy $w}
toplevel $w
wm title $w "Canvas Item Demonstration"
wm iconname $w "Items"
#positionWindow $w
set c $w.frame.c


frame $w.frame
pack $w.frame -side top -fill both -expand yes


canvas $c -scrollregion {0c 0c 300c 2400c} -width 150c -height 100c \
   -relief sunken -borderwidth 2 \
   -xscrollcommand "$w.frame.hscroll set" \
   -yscrollcommand "$w.frame.vscroll set"
scrollbar $w.frame.vscroll -command "$c yview"
scrollbar $w.frame.hscroll -orient horiz -command "$c xview"


grid $c -in $w.frame \
   -row 0 -column 0 -rowspan 1 -columnspan 1 -sticky news
grid $w.frame.vscroll \
   -row 0 -column 1 -rowspan 1 -columnspan 1 -sticky news
grid $w.frame.hscroll \
   -row 1 -column 0 -rowspan 1 -columnspan 1 -sticky news
grid rowconfig    $w.frame 0 -weight 1 -minsize 0
grid columnconfig $w.frame 0 -weight 1 -minsize 0


# Display a 3x3 rectangular grid.
 
# $c create rect 0c 0c 30c 24c -width 2
# $c create line 0c 8c 30c 8c -width 2
# $c create line 0c 16c 30c 16c -width 2
# $c create line 10c 0c 10c 24c -width 2
# $c create line 20c 0c 20c 24c -width 2
 

set font1 {Helvetica 12}
set font2 {Helvetica 24 bold}
if {[winfo depth $c] > 1} {
   set blue DeepSkyBlue3
   set red red
   set bisque bisque3
   set green SeaGreen3
} else {
   set blue black
   set red black
   set bisque black
   set green black
}
#
#$c create text 5c .2c -text Lines -anchor n ;# text

#$c create line 1c 1c 3c 1c 1c 4c 3c 4c -width 2m -fill $blue \
   -cap butt -join miter -tags item ;# blue Z

#$c create line 0c 0c 4c 4c -arrow last -tags item
#$c create line 0c 0c 4c 4c -arrow none -tags item
#$c create text 4c 4c -text ^ -anchor n ;# text

proc draw_line {vec {color black} {tag item} {arrow none}} {
   global c
   eval "$c create line [regsub -all { |$} $vec "c "] -arrow $arrow -tags $tag"
}
proc draw_mark {loc {text ""} {color black} {tag item} {arrow none}} {
   global c
   eval "$c create text [regsub -all { |$} $loc "c "] -text $text   -tags $tag"
}
set vec {3 1 7 3}

#draw_line $vec
#draw_mark {8 8} "*"

### Tree
package require struct

set LOAD_EXISTING_TREE 1
set SAVE_TREE 0
if {$LOAD_EXISTING_TREE} {
source T.save
} else {
catch {T destroy}
::struct::tree T

T insert root end n1
T insert root end n2
T insert n1 end n3
T insert n1 end n4
T insert n4 end n5
T insert n5 end n6
T insert n5 end n7
T insert n2 end n8
T insert n2 end n9
T insert n9 end n10
T insert n9 end n11

T insert n7 end n7_1
T insert n7 end n7_2

T insert n7_2 end n7_2_1
T insert n7_2 end n7_2_2

T insert n7_2_1 end n7_2_1_1
T insert n7_2_1 end n7_2_1_2
}

# SAVE T
if {$SAVE_TREE} {
set fp [open T.save w]
puts $fp "catch {T destroy}"
puts $fp {::struct::tree T}
puts $fp "T deserialize \{[T serialize]\}"
close $fp
}
#
proc dump_full_structure {} {
   global T
   set fp [open T.tk.full_structure w]
   T walk root -order pre -type dfs node {
      set n [T depth $node]
      set n1 $n
      while {$n1 >0} {
         puts -nonewline $fp "   ";
         puts -nonewline "   ";
         incr n1 -1
      }
      #puts [T get $node ]
      #puts "$node:\tlevel=$n"
      puts $fp [format "lv%s:%s" \
      $n\
      $node]
      #puts "node=$node;father=[T parent $node]"
      #puts "node=$node;child =[T children $node]"
   }
   close $fp
}

dump_full_structure 

proc is_leaf {t n} {
   if {![$t keyexists $n volume]} {return 0}
   return [$t isleaf $n]
}
#

   T walk root -order pre -type dfs node {
      set n [T depth $node]
      set n1 $n
      while {$n1 >0} {
         puts -nonewline "   ";
         incr n1 -1
      }
      #puts [T get $node ]
      #puts "$node:\tlevel=$n"
      puts [format "lv%s:%s" \
      $n\
      $node]
      puts "node=$node;father=[T parent $node]"
      puts "node=$node;child =[T children $node]"
      #
      if {$node ne "root"} {
      puts "node=$node;index =[T index $node]"
      } else {

      }
      #
      if {$node ne "root"} {
         set father_x [T get [T parent $node] x]
         set father_y [T get [T parent $node] y]

         set this_x [expr $father_x+$OFFSET_X]
         set SCALE  [expr 1.0/$n]
         set this_y [expr $father_y+$OFFSET_Y*$SCALE*[T index $node]]
      } else {
         T set root x 0.1
         T set root y 0.1
      }
      if {$node ne "root"} {
         puts "node=$node"
         set vec [list $father_x $father_y \
         $this_x $this_y]
         puts "node=$node;\{$vec\}"
         T set $node x $this_x
         T set $node y $this_y
         draw_line $vec
         #draw_mark [list $this_x $this_y] "O"
         draw_mark [list $this_x $this_y] $node
      }
   }
