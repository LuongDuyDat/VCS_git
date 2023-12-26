def main():
    arr = list(map(int, input("Moi ban nhap day so (theo thu tu tang dan): ").split()))
    n = int(input('Moi ban nhap so muon tim: '))
    low = 0
    high = len(arr) - 1

    cnt = 0
    while low <= high:
        if cnt == 10:
            break
        mid = int((low + high) / 2)
        if arr[mid] < n:
            low = mid + 1
        else:
            high = mid - 1
        cnt+=1
    
    if low == len(arr) or arr[low] > n:
        print("So ban tim khong co trong day")
    else:
        print("So ban tim nam o vi tri thu", low + 1, "trong day")
        

if __name__ == "__main__":
    main()