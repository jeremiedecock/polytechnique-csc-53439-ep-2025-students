# Build (from the project' root directory):
#   docker build -t jdhp/inf639:latest .

# Inspect:
#   docker run --rm -it jdhp/inf639:latest /bin/bash

# Push (from the project's root directory):
#   docker login -u jdhp
#   docker push jdhp/inf639:latest

# Run (from the project' root directory):
#   ssh ...
#   tmux ...
#   docker pull jdhp/inf639:latest
# then
# run only **one** learning process:
#   docker run -d  --rm -h aml1-docker --gpus all -e WANDB_API_KEY=$WANDB_API_KEY -v /home/jeremie/rl/xps:/xps jdhp/inf639:latest python3 /scripts/cleanrl_dqn_atari.py --env-id BreakoutNoFrameskip-v4 --track --save_model --capture_video --wandb_entity $WANDB_ENTITY --total_timesteps 500000 --buffer_size 50000
# run multiple learning processes sequentially:
#   docker run -it --rm -h aml1-docker --gpus all -e WANDB_API_KEY=$WANDB_API_KEY -v /home/jeremie/rl/xps:/xps jdhp/inf639:latest python3 /scripts/cleanrl_dqn_atari.py --env-id BreakoutNoFrameskip-v4 --track --save_model --capture_video --wandb_entity $WANDB_ENTITY --total_timesteps 500000 --buffer_size 50000
# (c.f. https://docs.wandb.ai/guides/track/environment-variables#optional-environment-variables )
# or
#   python3 -m venv env
#   source env/bin/activate
#   pip install --upgrade pip
#   pip install wandb
#   wandb login
#   wandb docker-run -h aml1-docker -v /home/jeremie/rl/xps:/xps -it jdhp/inf639:latest python3 /scripts/cleanrl_dqn_atari.py --env-id BreakoutNoFrameskip-v4 --track --save_model --capture_video --wandb_entity $WANDB_ENTITY --total_timesteps 500000 --buffer_size 50000
#     (c.f. https://docs.wandb.ai/ref/cli/wandb-docker-run )


FROM python:3.12-slim


# INSTALL SYSTEM DEPENDENCIES #################################################

RUN apt update --yes && \
    apt install --yes --no-install-recommends build-essential swig libbox2d2 && \
    apt autoremove && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*


# SET UP WORKDIR ##############################################################

WORKDIR /scripts


# UPGRADE PIP #################################################################

RUN pip install --no-cache-dir --upgrade pip


# INSTALL PYTHON DEPENDENCIES #################################################

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt


# SET UP WORKDIR ##############################################################

#WORKDIR /xps
