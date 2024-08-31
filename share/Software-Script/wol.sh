#!/bin/bash

INTERFACE="enp2s0"

ethtool -s $INTERFACE wol g
