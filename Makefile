NAMES=particles waves tunnel
MUXRATE=329289
VIDRATE=288000
ENCODE=-c:v libx264 -b:v $(VIDRATE) -f mpegts
STREAM=-c copy -f mpegts -muxrate $(MUXRATE) -streamid 0:256 -pcr_period 40 -pat_period 0.4 -mpegts_flags initial_discontinuity
OUTPUTS=$(addsuffix .ts,$(NAMES))

%.ts: %.mp4 Makefile
	ffmpeg -y -i $< $(ENCODE) -pass 1 pass1.ts
	ffmpeg -y -i pass1.ts $(ENCODE) -pass 2 pass2.ts
	ffmpeg -y -i pass2.ts $(STREAM) $@
	rm pass1.ts pass2.ts

all: $(OUTPUTS)

clean:
	rm -f $(OUTPUTS) pass1.ts pass2.ts
