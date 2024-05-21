import getpass

def main():
    auth_token = getpass.getpass(prompt='Enter your ngrok auth token: ')
    with open('ngrok_auth_token.txt', 'w') as f:
        f.write(auth_token)

if __name__ == '__main__':
    main()
