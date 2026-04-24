## Alert: High memory usage
Cause: Traffic spike or increased memory usage
Steps:
    1. kubectl top pods -n nodeapp
    2. kubectl logs -n nodeapp <pod> --tail=100
    3. kubectl scale deployment nodeapp -n nodeapp --replicas=3
    4. kubectl rollout undo deployment/nodeapp -n nodeapp

## Alert: Pod crash looping
Cause: Bad deploy, missing env var, DB connection failure
Steps:
    1. kubectl describe pod -n nodeapp (pod)
    2. kubectl logs -n nodeapp (pod) --previous
    3. Verify Secret and ConfigMap values are correct
    4. Rollback: kubectl rollout undo deployment/nodeapp -n nodeapp

## Node not Ready
Steps:
    1. sudo systemctl status k3s
    2. sudo journalctl -u k3s -n 50 {checking logs of your k3s service.}
    3. sudo systemctl restart k3s
    