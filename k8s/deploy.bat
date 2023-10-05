@echo off

REM Path to nginx yaml
set fileNginx="nginx-controller.yaml"

REM Path to spring-app yaml
set fileSpringApp="spring-app-deployment.yaml"

echo Adding %fileNginx% to kubernetes cluster in namespace nginx-controller..
kubectl apply -f "%fileNginx%"

echo.

echo Adding %fileSpringApp% to kubernetes cluster in namespace test-app..
kubectl apply -f "%fileSpringApp%"

echo.

echo Deploy SUCCESS. Have a nice day!!!

echo.

pause