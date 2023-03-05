#!/vendor/bin/sh

RED="/sys/class/leds/red/brightness"
GREEN="/sys/class/leds/green/brightness"
BLUE="/sys/class/leds/blue/brightness"

# We set the maximum brightness to 255
MAX_BRIGHTNESS=255
# Number of colors of the rainbow
NUM_COLORS=7

# Function to calculate RGB values for each color of the rainbow
# (https://stackoverflow.com/a/22649803)
rainbow_color() {
  if [ $1 -lt 60 ]; then
    R=255
    G=$(( 4 * $1 ))
    B=0
  elif [ $1 -lt 120 ]; then
    R=$(( 255 - (4 * ($1 - 60)) ))
    G=255
    B=0
  elif [ $1 -lt 180 ]; then
    R=0
    G=255
    B=$(( 4 * ($1 - 120) ))
  elif [ $1 -lt 240 ]; then
    R=0
    G=$(( 255 - (4 * ($1 - 180)) ))
    B=255
  elif [ $1 -lt 300 ]; then
    R=$(( 4 * ($1 - 240) ))
    G=0
    B=255
  else
    R=255
    G=0
    B=$(( 255 - (4 * ($1 - 300)) ))
  fi
}

rainbow() {
    # Start the rainbow
    for i in `seq 4`; do
        for i in $(seq 0 $(($NUM_COLORS - 1))); do
        # We calculate the RGB values for the current color
        rainbow_color $((360 * $i / $NUM_COLORS))
        # We set the brightness value for each led based on the calculated RGB values
        echo $MAX_BRIGHTNESS > $RED
        echo $(( $MAX_BRIGHTNESS * $R / 255 )) > $RED
        echo $MAX_BRIGHTNESS > $GREEN
        echo $(( $MAX_BRIGHTNESS * $G / 255 )) > $GREEN
        echo $MAX_BRIGHTNESS > $BLUE
        echo $(( $MAX_BRIGHTNESS * $B / 255 )) > $BLUE
        # Wait for the duration of the current color
        sleep 0.3
        done
    done
    EXIT
}

EXIT() {
    # Reset channels
    echo 0 | tee $BLUE $GREEN $RED
    exit 0
}

rainbow
