#!/bin/bash

INTERFACE="enp3s0"

ethtool -s $INTERFACE wol g
