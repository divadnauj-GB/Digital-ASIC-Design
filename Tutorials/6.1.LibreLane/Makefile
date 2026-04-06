NAME=rgb_mixer_chip
CONFIG=config.json

librelane:
	rm -rf runs/$(NAME)
	librelane --manual-pdk $(CONFIG) --run-tag $(NAME) 

clean:	
	rm -rf runs