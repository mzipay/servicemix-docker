cat <<EOF >>/home/oracle/.bashrc

export PS1="[\\u@\\h]\\\$ "

export EDITOR=vi

function sqlplus {
        socat READLINE,history=\$HOME/.sqlplus_history EXEC:"$ORACLE_HOME/bin/sqlplus \$(echo \$@ | sed 's/\\([\\:]\\)/\\\\\\1/g')",pty,setsid,ctty
        status=$?
}

cd
EOF

chown oracle:oinstall /home/oracle/.bashrc

