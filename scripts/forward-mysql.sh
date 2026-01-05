#!/bin/bash

kubectl port-forward svc/mysql-primary -n argocd 3306:3306